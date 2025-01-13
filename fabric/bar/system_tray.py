from fabric.system_tray.widgets import SystemTray

# SystemTray but automatically hide when there is no icons
class SelfHiddingSystemTray(SystemTray):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self._watcher.on_item_added = self.on_item_added
        self._watcher.on_item_removed = self.on_item_removed
        self.hide()

    def on_item_added(self, _, item_identifier):
        print(item_identifier)
        super().on_item_added(_, item_identifier)
        self.show()

    def on_item_removed(self, _, item_identifier):
        super().on_item_removed(_, item_identifier)
        if len(self._items) == 0:
            self.hide()

