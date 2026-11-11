#!/usr/bin/env python3
"""
Minimal Telegram echo/ping bot using raw long-polling.
Token is read from TELEGRAM_BOT_TOKEN env var — never hardcoded.
"""

import logging
import os
import re
import sys
import time

import requests

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
    stream=sys.stdout,
)
log = logging.getLogger(__name__)

TOKEN = os.environ.get("TELEGRAM_BOT_TOKEN")
if not TOKEN:
    log.error("TELEGRAM_BOT_TOKEN is not set — exiting.")
    sys.exit(1)

BASE = f"https://api.telegram.org/bot{TOKEN}"


def scrub(exc: BaseException) -> str:
    """Exception text that is safe to log.

    requests puts the full request URL in its exception messages, and the
    Telegram URL contains the bot token (/bot<TOKEN>/method). Never log
    str(exc) directly.
    """
    text = str(exc).replace(TOKEN, "<token>")
    text = re.sub(r"bot\d+:[A-Za-z0-9_-]+", "bot<token>", text)  # belt and braces
    return f"{type(exc).__name__}: {text}"


def api(method: str, **kwargs) -> dict:
    resp = requests.post(f"{BASE}/{method}", json=kwargs, timeout=35)
    resp.raise_for_status()
    data = resp.json()
    if not data.get("ok"):
        raise RuntimeError(f"Telegram error: {data}")
    return data["result"]


def send(chat_id: int, text: str) -> None:
    api("sendMessage", chat_id=chat_id, text=text)


def handle(update: dict) -> None:
    msg = update.get("message") or update.get("edited_message")
    if not msg:
        return
    chat_id = msg["chat"]["id"]
    text = msg.get("text", "")

    if text.startswith("/start"):
        send(chat_id, "👋 Hi! I'm a demo bot running on Azure Container Instances.\nTry /ping or just send me any message.")
    elif text.startswith("/ping"):
        send(chat_id, "pong 🏓")
    elif text:
        send(chat_id, f"Echo: {text}")


def poll() -> None:
    log.info("Bot starting — long-polling Telegram API.")
    offset = 0
    backoff = 1

    while True:
        try:
            updates = api("getUpdates", offset=offset, timeout=30, allowed_updates=["message"])
            backoff = 1
            for u in updates:
                try:
                    handle(u)
                except Exception as exc:
                    log.warning("handle error for update %s: %s", u.get("update_id"), scrub(exc))
                offset = u["update_id"] + 1
        except requests.exceptions.RequestException as exc:
            log.warning("network error (%s) — retrying in %ds", scrub(exc), backoff)
            time.sleep(backoff)
            backoff = min(backoff * 2, 60)
        except Exception as exc:
            log.error("unexpected error: %s", scrub(exc))
            time.sleep(backoff)
            backoff = min(backoff * 2, 60)


if __name__ == "__main__":
    poll()
