""" Module for aiohttp signals """

from src.db import Connection


async def on_startup(_):
    """ Function that will called on server starting """

    Connection()
