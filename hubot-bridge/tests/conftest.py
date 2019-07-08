""" Module for test fixtures """

import pytest

from src.utils import make_app


@pytest.fixture
async def client(aiohttp_client):
    """ aiohttp client """

    return await aiohttp_client(make_app())
