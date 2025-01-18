from gi.repository import GLib
from time import time

class Timer():
    timeout = None
    callback = None
    started = False

    _time_left = 0
    _start_time = None
    _timeout_id = None

    def __init__(self, timeout = 1000, callback = None):
        self.timeout = timeout
        self.callback = callback

    def _timeout_callback(self):
        self.started = False
        self._time_left = 0
        self._start_time = None
        self._timeout_id = None

        if self.callback:
            return self.callback()
        return False

    def start(self):
        if not self.timeout:
            return

        self.stop()
        self._time_left = self.timeout
        self._start_time = time() * 1000
        self.started = True
        self._timeout_id = GLib.timeout_add(self.timeout, self._timeout_callback)

    def stop(self):
        self.started = False
        if self._timeout_id:
            GLib.source_remove(self._timeout_id)
            self._timeout_id = None

            if self._start_time:
                self._time_left -= time() * 1000 - self._start_time
                self._start_time = None

    def resume(self):
        if self._time_left <= 0:
            return

        self.stop()
        self._start_time = time() * 1000
        self.started = True
        self._timeout_id = GLib.timeout_add(self._time_left, self._timeout_callback)
