""" Module for server initialization """

from aiohttp import web

from src.router import ROUTER
from src.signals import on_startup


SERVER = web.Application()

SERVER.on_startup.append(on_startup)

SERVER.add_routes(ROUTER)
