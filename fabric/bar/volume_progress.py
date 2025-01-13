from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.overlay import Overlay
from fabric.widgets.eventbox import EventBox
from fabric.widgets.circularprogressbar import CircularProgressBar

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

