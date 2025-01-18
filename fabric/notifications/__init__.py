from typing import cast

from fabric.widgets.box import Box
from fabric.widgets.eventbox import EventBox
from fabric.widgets.label import Label
from fabric.widgets.image import Image
from fabric.widgets.button import Button
from fabric.widgets.wayland import WaylandWindow
from fabric.notifications import NotificationAction, Notifications, Notification

from utils.timer import Timer

from gi.repository import GdkPixbuf


NOTIFICATION_WIDTH = 360
NOTIFICATION_HEIGHT = 90
NOTIFICATION_IMAGE_HEIGHT = NOTIFICATION_HEIGHT - 6*2
NOTIFICATION_TIMEOUT = 6 * 1000


class ActionButton(Button):
    def __init__(self, action: NotificationAction, timer: Timer, **kwargs):
        super().__init__(
            style_classes = "action-button",
            h_expand = True,
            v_expand = True,
            label = action.label,
            on_clicked = self.on_clicked,
            **kwargs
        )

        self.action = action

        self.connect("enter-notify-event", lambda *_: timer.stop())
        # self.connect("leave-notify-event", lambda *_: timer.resume())

    def on_clicked(self, _):
        self.action.invoke()
        self.action.parent.close("dismissed-by-user")

class NotificationWidget(EventBox):
    def __init__(self, notification: Notification, **kwargs):
        super().__init__(
            style_classes = "notification",
            events = [ "button-press", "enter-notify", "leave-notify" ],
            size = (NOTIFICATION_WIDTH, NOTIFICATION_HEIGHT),
            visible = False,
            all_visible = False,
            **kwargs,
        )
        if notification.urgency < 2:
            self.add_style_class("normal")
        else:
            self.add_style_class("urgent")

        self._notification = notification

        # a container to contain everything since EventBox only allowed to have one child
        container = Box(
            style_classes = "notification-container",
            spacing = 4,
            orientation = "v",
        )
        self.add(container)

        self.expired_timer = Timer(
            timeout = self._notification.timeout,
            callback = lambda: self._notification.close("expired")
        )
        if self.expired_timer.timeout == -1:
            self.expired_timer.timeout = NOTIFICATION_TIMEOUT

        # do not dismiss critical notifications
        if self._notification.urgency == 2:
            self.expired_timer.timeout = 0

        self.connect("enter-notify-event", lambda *_: self.expired_timer.stop())
        self.connect("leave-notify-event", lambda *_: self.expired_timer.start())
        self.connect("button-press-event", lambda *_: self._notification.close("dismissed-by-user"))

        body_container = Box(spacing = 4, orientation = "h")
        container.add(body_container)

        image_path = None
        if self._notification.image_file:
            image_path = self._notification.image_file
        elif self._notification.app_icon:
            image_path = self._notification.app_icon

        if image_path:
            body_container.add(Image(
                image_file = image_path,
                size = (-1, NOTIFICATION_IMAGE_HEIGHT),
            ))
        elif image_pixbuf := self._notification.image_pixbuf:
            body_container.add(
                Image(
                    pixbuf = image_pixbuf.scale_simple(
                        -1,
                        NOTIFICATION_IMAGE_HEIGHT,
                        GdkPixbuf.InterpType.BILINEAR,
                    ),
                )
            )

        body_container.add(
            Box(
                spacing = 4,
                orientation = "v",
                children = [
                    Label(
                        label = self._notification.summary,
                        style_classes = "summary",
                        v_align = "center",
                        h_align = "start",
                    ),
                    Label(
                        label = self._notification.body,
                        style_classes = "body",
                        line_wrap = "word-char",
                        v_align = "start",
                        h_align = "start",
                    ),
                ],
                h_expand = True,
                v_expand = True,
            )
        )

        if actions := self._notification.actions:
            container.add(Box(
                spacing = 4,
                orientation = "h",
                children = [ ActionButton(action, self.expired_timer) for action in actions ],
            ))

        # destroy this widget once the notification is closed
        self._notification.connect(
            "closed",
            lambda *_: (
                parent.remove(self) if (parent := self.get_parent()) else None, # type ignore
                self.destroy(),
            ),
        )

        if self.expired_timer.timeout != 0:
            self.expired_timer.start()

        self.show()

        # overflown notifs will show with clipped area
        # so we need to force redraw it

        # force redraw with hacks
        Timer(10, self.hide).start()
        Timer(100, self.show).start()

    def destroy(self):
        self.expired_timer.stop()
        super().destroy()

class NotificationContainer(Box):
    def __init__(self, **kwargs):
        super().__init__(
            size = 2, # so it's not ignored by the compositor
            spacing = 4,
            orientation = "v",
            **kwargs
        )

        self.build(
            lambda viewport, _: Notifications(
                on_notification_added = lambda notifs_service, nid: viewport.add(
                    NotificationWidget(
                        cast(
                            Notification,
                            notifs_service.get_notification_from_id(nid),
                        )
                    )
                )
            )
        )

class NotificationWindow(WaylandWindow):
    def __init__(self, **kwargs):
        super().__init__(
            margin = "8px 8px 8px 8px",
            anchor = "top right",
            child = NotificationContainer(),
            visible = True,
            all_visible = True,
            **kwargs
        )
