from fabric.widgets.box import Box
from fabric.widgets.button import Button
from fabric.widgets.datetime import DateTime
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.hyprland.widgets import Workspaces, WorkspaceButton

from bar.volume_progress import VolumeProgressBar
from bar.system_tray import SelfHiddingSystemTray

from panel import Panel

class Bar(Window):
    def __init__(self):
        super().__init__(
            name = "bar",
            layer = "top",
            anchor = "left top center bottom",
            margin = "20px -15px 20px 20px",
            exclusivity = "auto",
            visible = False,
            all_visible = False,
            v_align = "center",
        )

        self.dashboard = Panel(margin = "20px 0px 0px 20px")
        self.dashboard.hide()

        self.panel_button = Button(label = "a")
        self.panel_button.connect("clicked", self.panel_button_callback)

        self.workspace_buttons = Workspaces(
            name = "workspace-buttons",
            spacing = 4,
            orientation = 'v',
            buttons = self.generate_workspace_buttons(6),
            buttons_factory = self.make_workspace_button,
        )

        self.datetime = DateTime(
            style_classes = "widgets-container",
            name = "datetime-widget",
            formatters = [ "%H\n%M", "%d\n%m" ],
            interval = 15 * 1000,
        )

        self.system_tray = SelfHiddingSystemTray(
            name = "system-tray",
            orientation = 'v',
            spacing = 4,
            style_classes = "widgets-container"
        )

        self.volume_widget = self.generate_widgets_container(4)
        self.volume_widget.add(VolumeProgressBar())

        self.children = CenterBox(
            name = "bar-inner",
            orientation = "v",
            start_children = Box(
                spacing = 4,
                orientation = "v",
                children = [
                    self.panel_button,
                    self.datetime,
                ],
            ),
            center_children = Box(
                spacing = 4,
                orientation = "v",
                children = self.workspace_buttons,
            ),
            end_children = Box(
                spacing = 4,
                orientation = "v",
                children = [
                    self.system_tray,
                    self.volume_widget,
                ],
            ),
        )

        self.show()

    def panel_button_callback(self, _):
        if self.dashboard.get_visible():
            self.dashboard.hide()
        else:
            self.dashboard.show()

    def make_workspace_button(self, ws_id):
        return WorkspaceButton(id = ws_id, label = None, h_align = "center")

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
