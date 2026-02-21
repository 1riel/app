import os
import sys

sys.path.append(os.getcwd())


from telegram.ext import *
from server.Environment import *

# from server.utilities.Debug import debug


class Telegram_Bot:
    def __init__(self, token: str = BOT_TOKEN):
        self.application = Application.builder().token(token).build()
        self._register_handlers()
        print("Telegram bot initialized")

    def _register_handlers(self):
        self.application.add_handler(CommandHandler("start", self.start))
        self.application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, self.echo))
        print("Handlers registered")

    async def start(self, update, _context):
        try:
            data = update.message.to_dict()
            user_id = data["from"]["id"]

            await update.message.reply_text(f"Your Telegram ID is:")
            await update.message.reply_text(f"{user_id}")

            print(f"/start called by user_id: {user_id}")
            print(f"Message dict: {update.message.to_dict()}")

        except Exception as e:
            print(e)

    async def echo(self, update, _context):
        try:
            user_message = update.message.text
            await update.message.reply_text(f"You said: {user_message}")

            print(f"Echo message from {update.message.from_user.id}: {user_message}")
        except Exception as e:
            print(e)

    def run(self):
        # try to make stdout/stderr line-buffered so prints appear in journal promptly
        try:
            if hasattr(sys.stdout, "reconfigure"):
                sys.stdout.reconfigure(line_buffering=True)
                sys.stderr.reconfigure(line_buffering=True)
            else:
                sys.stdout = os.fdopen(sys.stdout.fileno(), "w", buffering=1)
                sys.stderr = os.fdopen(sys.stderr.fileno(), "w", buffering=1)
        except Exception:
            pass

        print("Starting Telegram bot polling...", flush=True)
        try:
            self.application.run_polling()
        except Exception as e:
            print(e, flush=True)
        print("Telegram bot stopped", flush=True)


if __name__ == "__main__":
    print("Telegram Service Running ...")
    service = Telegram_Bot()
    service.run()
