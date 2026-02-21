import platform
from rich import print

from Environment import *


def debug(string: str):
    if platform.node() != SERVER_NAME:
        print(string)
