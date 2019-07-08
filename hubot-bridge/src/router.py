""" Module for routing """

from aiohttp import web
from src.views import get_locale

ROUTER = [web.get('/locale', get_locale), ]
