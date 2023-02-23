#!/usr/bin/env python

import argparse
import signal
import socket
import time
from collections import OrderedDict

STATUS_CMD = "\x00\x06status".encode()
EOF = "  \n\x00\x00"
SEP = ":"
BUFFER_SIZE = 1024

UNITS = (
    "C",
    "VA",
    "Hz",
    "Amps",
    "Watts",
    "Volts",
    "Percent",
    "Seconds",
    "Minutes",
    "Percent Load Capacity"
)


def strip_apc_units(lines):
  for line in lines:
    for unit in UNITS:
      if line.endswith(" %s" % unit):
        line = line[:-1-len(unit)]
    yield line


def printData(values, data, writer):
  if 'all' in values:
    for v in data.keys():
      writer.write("%s %s" % (v, data[v]))
  else:
    for v in values:
      writer.write("%s %s" % (v, data[v]))


class FileWriter:
  def __init__(self, path="/tmp/apcaccess.out"):
    self.path = path
    self.lines = []

  def write(self, data):
    self.lines += [data]

  def flush(self):
    with open(self.path, 'w') as f:
      for line in self.lines:
        print(line, file=f)

    self.lines.clear()


class StdWriter:
  def write(self, data):
    print(data)

  def flush(self):
    pass


class ApcAccess:
  def __init__(self, host="localhost", port=3551, timeout=30):
    """
    Connect to apcupsd port and get data.
    """
    self.host = host
    self.port = port
    self.timeout = timeout

  def connect(self):
    self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    self.sock.settimeout(self.timeout)
    self.sock.connect((self.host, self.port))

  def close(self):
    self.sock.close()

  def _getStatus(self):
    self.sock.send(STATUS_CMD)

    buffer = ""
    while not buffer.endswith(EOF):
      buffer += self.sock.recv(BUFFER_SIZE).decode()

    return buffer

  def getData(self):
    buf = self._getStatus()

    lines = [x[1:-1] for x in buf[:-len(EOF)].split("\x00") if x]
    lines = strip_apc_units(lines)

    return OrderedDict([[x.strip() for x in x.split(SEP, 1)] for x in lines])


class Runner:
  def __init__(self, args):
    self.args = args
    if args.output == '-':
      self.writer = StdWriter()
    else:
      self.writer = FileWriter(args.output)

  def run(self):
    a = ApcAccess(self.args.host, self.args.port)
    a.connect()

    if self.args.follow != -1:
      self.follow = True
      f = self.args.follow

      while self.follow:
        data = a.getData()
        printData(self.args.values, data, self.writer)
        self.writer.flush()
        time.sleep(f)

    else:
      data = a.getData()
      printData(self.args.values, self.writer)
      self.writer.flush()

    a.close()

  def sigint(self, signum, frame):
    self.follow = False


def main():
  parser = argparse.ArgumentParser(
      prog='ApcAccess.py',
      description='python apc access util')

  parser.add_argument('--host',
                      default='localhost',
                      help='host to connect to')
  parser.add_argument('-p', '--port',
                      default=3551,
                      help='port to connect to')
  parser.add_argument('-o', '--output',
                      default='-', type=str,
                      help='output path or stdout (-)')
  parser.add_argument('-f', '--follow',
                      default=-1,
                      type=float,
                      help='continue to pull and update')
  parser.add_argument('values', nargs='+')

  runner = Runner(parser.parse_args())
  signal.signal(signal.SIGINT, runner.sigint)
  runner.run()


if __name__ == '__main__':
  main()
