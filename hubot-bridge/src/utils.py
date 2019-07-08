""" Module for server utils """

from aiohttp import web

from src.router import ROUTER
from src.signals import on_startup


def make_app():
    """ Function for creating the server instance """

    app = web.Application()

    app.on_startup.append(on_startup)

    app.add_routes(ROUTER)
    return app
