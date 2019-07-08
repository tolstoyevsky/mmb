""" Module for server running """

from aiohttp import web

from src.server import SERVER
from src.settings import PORT, HOST


if __name__ == "__main__":
    web.run_app(
        SERVER,
        port=PORT,
        host=HOST
    )
