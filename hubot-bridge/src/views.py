""" Module for views """

from aiohttp import web

from src.db import Connection


async def get_locale(request):
    """Handler for getting user locale by id"""
    try:
        user_id = request.rel_url.query['user_id']
    except KeyError:
        raise web.HTTPBadRequest(text="user_id not found")
    conn = Connection()
    document = await conn.connection.rocketchat.users.find_one(
        {"_id": user_id})
    if not document:
        raise web.HTTPNotFound()
    locale = document.get("language", "")
    return web.json_response({"status": "ok", "locale": locale})
