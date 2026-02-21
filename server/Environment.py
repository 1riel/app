import os
import sys

sys.path.append(os.getcwd())


if os.path.exists("Environment_Pro.py"):
    from Environment_Pro import *
else:
    from Environment_Dev import *
