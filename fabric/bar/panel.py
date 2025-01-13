from fabric.widgets.box import Box
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow as Window

class Panel(Window):
    def __init__(self):
        super().__init__(
            style_classes = "panel",
            layer = "top",
            # anchor = "top-left center-left bottom-left",
            # margin = "20px -10px 20px 20px",
            exclusivity = "auto",
            visible = False,
            all_visible = False,
        )

        self.children = Box(
            style_classes = "panel-inner",
            children = [
                Label(markup = "<b>ngu</b>\nfabric is fucking cool"),
            ]
        )

        self.show()
