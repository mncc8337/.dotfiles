from fabric import Application
from fabric.utils import (
    get_relative_path,
)

from bar import Bar
bar = Application("bar", Bar())
bar.set_stylesheet_from_file(get_relative_path("./bar/style.css"))
bar.run()
