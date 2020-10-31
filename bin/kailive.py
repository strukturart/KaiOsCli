import threading
import time
import kaiscr
from gi.repository import Gtk, GdkPixbuf, GLib

takescreenshot = kaiscr.TakeScreenshot().screenshot
window = Gtk.Window()
window.connect("destroy", Gtk.main_quit)
img = None

def update_pic():
    global img
    global takescreenshot

    while 1:
        loader = GdkPixbuf.PixbufLoader()
        loader.write(takescreenshot())
        pb = loader.get_pixbuf()
        if not img:
            img = Gtk.Image.new_from_pixbuf(pb)
        else:
            img.set_from_pixbuf(pb)
        loader.close()


t = threading.Thread(target=update_pic)
t.start()
while not img:
    time.sleep(0.1)
window.add(img)
window.show_all()
Gtk.main()


