""" Module for server settings """

import os

PORT = int(os.getenv('PORT') or '8000')
HOST = os.getenv('HOST') or 'localhost'

MONGODB_HOST = os.getenv('MONGODB_HOST') or 'localhost'
MONGODB_PORT = int(os.getenv('MONGODB_PORT') or '27017')
