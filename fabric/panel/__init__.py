from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow as Window

class Panel(Window):
    def __init__(self, **kwargs):
        super().__init__(
            style_classes = "panel",
            layer = "overlay",
            anchor = "top left",
            exclusivity = "none",
            visible = False,
            all_visible = False,
            h_align = "center",
            v_align = "center",
            **kwargs
        )

        self.children = Box(
            style_classes = "panel-inner",
            children = [
                Label(markup = "<b>ngu</b>\nfabric is fucking cool"),
            ]
        )

        self.show()
