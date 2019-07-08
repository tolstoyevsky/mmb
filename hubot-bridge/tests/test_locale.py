""" Tests for locale module """

async def test_for_existing_user(client):
    """ Test Case for getting locale of existing user """

    resp = await client.get("/locale?user_id=rocket.cat")
    assert resp.status == 200
    data = await resp.json()
    assert "ru" in data["locale"]


async def test_for_nonexistent_locale(client):
    """ Test Case for getting locale of existing user without locale """

    resp = await client.get("/locale?user_id=rocket.dog")
    assert resp.status == 200
    data = await resp.json()
    assert "" in data["locale"]


async def test_for_nonexistent_user(client):
    """ Test Case for getting locale of nonexisting user """

    resp = await client.get("/locale?user_id=qwerty")
    assert resp.status == 404


async def test_for_bad_request(client):
    """ Test Case for getting locale with bad queries """

    resp = await client.get("/locale")
    assert resp.status == 400
    text = await resp.text()
    assert "user_id not found" in text

    resp = await client.get("/locale?test=qwerty")
    assert resp.status == 400
    text = await resp.text()
    assert "user_id not found" in text
