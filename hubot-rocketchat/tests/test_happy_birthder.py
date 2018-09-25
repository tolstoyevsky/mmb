#!/usr/bin/env python3
from base import create_user, remove_user


def run_script(browser, log):
    log.info('CREATING USER...')
    create_user(browser, log)

    pass
    """
    Here will be testing happy birthder
    """

    log.info('REMOVING USER...')
    remove_user(browser, log)
