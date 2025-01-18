from fabric import Application
from fabric.utils import (
    get_relative_path,
)

from bar import Bar
from notifications import NotificationWindow

app = Application("fabric-shell", Bar(), NotificationWindow())
app.set_stylesheet_from_file(get_relative_path("./main.css"))
app.run()
