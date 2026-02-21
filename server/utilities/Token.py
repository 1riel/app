import os
import sys

sys.path.append(os.getcwd())

# from server.utilities.Debug import debug


import secrets
import string


class Token:
    alphabet = string.ascii_letters + string.digits  # 62 chars [a-zA-Z0-9]

    def gen(self, length: int = 8) -> str:
        return "".join(secrets.choice(self.alphabet) for _ in range(length))
