from datetime import datetime

from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.overlay import Overlay
from fabric.widgets.eventbox import EventBox
from fabric.widgets.datetime import DateTime
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.circularprogressbar import CircularProgressBar
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.system_tray.widgets import SystemTray
from fabric.hyprland.widgets import ActiveWindow, Workspaces, WorkspaceButton
from fabric.utils import (
    invoke_repeater,
    get_relative_path,
)

from fabric.audio.service import Audio

class VolumeProgressBar(Box):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.audio = Audio()

        self.progress_bar = CircularProgressBar(
            name = "volume-progress-bar", pie = True, size = 24,
        )

        self.event_box = EventBox(
            events = "scroll",
            child = Overlay(
                child = self.progress_bar,
                overlays = Label(
                    label = "",
                    style = "margin: 0px 6px 0px 0px; font-size: 12px", 
                ),
            ),
        )

        self.audio.connect("notify::speaker", self.on_speaker_changed)
        self.event_box.connect("scroll-event", self.on_scroll)
        self.add(self.event_box)

    def on_scroll(self, _, event):
        match event.direction:
            case 0:
                self.audio.speaker.volume -= 2
            case 1:
                self.audio.speaker.volume += 2
        return

    def on_speaker_changed(self, *_):
        if not self.audio.speaker:
            return
        self.progress_bar.value = self.audio.speaker.volume / 100
        self.audio.speaker.bind(
            "volume", "value", self.progress_bar, lambda _, v: v / 100
        )
        return

# SystemTray but automatically hide when there is no icons
class SelfHiddingSystemTray(SystemTray):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self._watcher.on_item_added = self.on_item_added
        self._watcher.on_item_removed = self.on_item_removed

        # hide the widget after 10ms. hiding it instantly will not work
        invoke_repeater(10, self.hide)

    def on_item_added(self, _, item_identifier):
        super().on_item_added(_, item_identifier)
        if not self.is_visible:
            self.show()

    def on_item_removed(self, _, item_identifier):
        super().on_item_removed(_, item_identifier)
        if len(self._items) == 0:
            self.hide()

class StatusBar(Window):
    def __init__(self):
        super().__init__(
            name = "bar",
            layer = "top",
            anchor = "top-left center-left bottom-left",
            margin = "20px -10px 20px 20px",
            exclusivity = "auto",
            visible = False,
            all_visible = False,
        )
        self.workspaces = Workspaces(
            name = "workspaces",
            spacing = 4,
            orientation = 'v',
            buttons = self.generate_workspace_buttons(6),
            buttons_factory = self.make_workspace_button,
        )

        self.datetime_container = self.generate_widgets_container(4)
        self.datetime_container.add(DateTime(
            name = "datetime",
            formatters = [ "%H\n%M", "%d\n%m" ],
            interval = 15 * 1000,
        ))

        self.system_tray = SelfHiddingSystemTray(name = "system-tray", spacing = 4, style_classes = "widgets-container")

        self.volume_widget = self.generate_widgets_container(4)
        self.volume_widget.add(VolumeProgressBar())

        self.children = CenterBox(
            name = "bar-inner",
            orientation = "v",
            start_children = Box(
                name = "start-container",
                spacing = 4,
                orientation = "v",
                children = [
                ],
            ),
            center_children = Box(
                name = "center-container",
                spacing = 4,
                orientation = "v",
                children = self.workspaces,
            ),
            end_children = Box(
                name = "end-container",
                spacing = 4,
                orientation = "v",
                children = [
                    self.datetime_container,
                    self.system_tray,
                    self.volume_widget,
                ],
            ),
        )

        self.show_all()

    def make_workspace_button(self, ws_id):
        return WorkspaceButton(id = ws_id, label = None)

    def generate_workspace_buttons(self, n):
        buttons = []
        for i in range(1, n + 1):
            buttons.append(self.make_workspace_button(i))
        return buttons

    def generate_widgets_container(self, spacing):
        container = Box(
            spacing = spacing,
            orientation = 'v',
            style_classes = "widgets-container",
        )
        return container

    
if __name__ == "__main__":
    bar = StatusBar()
    app = Application("bar", bar)
    app.set_stylesheet_from_file(get_relative_path("./style.css"))

    app.run()
