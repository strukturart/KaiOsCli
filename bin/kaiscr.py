#!/usr/bin/python3
import socket
import base64
import json
import sys

class TakeScreenshot:
    def __init__(self, host="127.0.0.1", port=6000):
        self.screenshot_cmd = '{"type":"screenshotToDataURL","to":"%s"}'
        self.listTabs_cmd = '{"to":"root","type":"listTabs"}'
        self.substring_cmd='{"type":"substring","start":%d,"end":%d,"to":"%s"}'
        self.sock = socket.socket()
        self.sock.connect((host, port))

        buffer = b""
        while not buffer.endswith(b":"):
            buffer += self.sock.recv(1)
        size = int(buffer.replace(b":", b""))
        buffer = b""
        while len(buffer) < size:
            buffer += self.sock.recv(size)
        # Do something with it if you want.

        self.sock.send(self.__with_len(self.listTabs_cmd))
        buffer = b""
        while not buffer.endswith(b":"):
            buffer += self.sock.recv(1)
        size = int(buffer.replace(b":", b"").decode())
        self.deviceActor = json.loads(self.sock.recv(size))["deviceActor"]

    def __with_len(self, command):
        return str(len(command)).encode() + b":" + command.encode()
    
    def __receive(self, size):
        buffer = b""
        while len(buffer) < size:
            buffer += self.sock.recv(1)
        return buffer

    def screenshot(self):
        cmd = self.__with_len(self.screenshot_cmd % self.deviceActor)
        self.sock.send(cmd)
        buffer = b""
        while not buffer.endswith(b":"):
            buffer += self.sock.recv(1)
        size = int(buffer.replace(b":", b"").decode())
        buffer = self.__receive(size)
        image = json.loads(buffer)["value"]
        if type(image) == str:
            return base64.b64decode(image.split(",")[1])
        image_len = image["length"]
        actor = image["actor"] 
        cmd = self.substring_cmd % (0, image_len, actor)
        self.sock.send(self.__with_len(cmd))

        buffer = b""
        while not buffer.endswith(b":"):
            buffer += self.sock.recv(1)
        buffer = self.__receive(int(buffer.replace(b":", b"")))
        image = json.loads(buffer)["substring"].split(",")[1]
        image += "=" * (-len(image) % 4)
        return base64.b64decode(image)
    
    def close(self):
        self.sock.close()

if __name__ == "__main__":
    from argparse import ArgumentParser
    d = "Take screenshot(s) from a KaiOS/FFOS device"
    parser = ArgumentParser(description = d)
    parser.add_argument("--host",
        metavar = "host",
        type = str,
        default = "127.0.0.1",
        help = "The host to connect to")

    parser.add_argument("--port",
        metavar = "port",
        type = int,
        default = 6000,
        help = "The port to connect to")
    parser.add_argument("--prefix",
        metavar = "prefix",
        type = str,
        default = "out",
        help = "The prefix for naming files")
    parser.add_argument("--count",
        metavar = "count",
        type = int,
        default = 1,
        help = "How many times should I take screenshot? 0 does nothing and negative values take screenshot forever")

    args = parser.parse_args()
    if args.count == 0:
        sys.exit(0)
    takeScreenshot = TakeScreenshot(args.host, args.port)
    c = 1
    try:
        while c <= args.count or args.count < 0:
            c += 1
            with open(args.prefix + str(c) + ".png", "wb") as fp:
                fp.write(takeScreenshot.screenshot())
    finally:
        takeScreenshot.close()


