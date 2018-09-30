#!/usr/bin/env python3
import argparse
import os

from dotenv import load_dotenv
from splinter import Browser

from base import logging
import happy_birthder

BROWSER_WINDOW_SIZE = (1920, 1080)
BOTS_FOR_TESTING = [happy_birthder]


def main():
    log = logging()
    browser = Browser('chrome', headless=False, wait_time=30,
                      executable_path='./drivers/chromedriver')

    log.info('Initialize Browser')
    browser.driver.set_page_load_timeout(30)
    log.info('success!')

    log.info('Resize window')
    browser.driver.set_window_size(*BROWSER_WINDOW_SIZE)
    log.info('success!')

    log.info('Visit url')
    browser.visit('localhost:8006')
    log.info('success!')

    log.info('Fill username')
    browser.fill('emailOrUsername', os.getenv('SIGN_IN_USERNAME'))
    log.info('success!')

    log.info('Fill password')
    browser.fill('pass', os.getenv('SIGN_IN_PASSWORD'))
    log.info('success!')

    log.info('Click login button')
    login_btn = browser.find_by_css('.rc-button.rc-button--primary.login')
    login_btn.click()
    log.info('success!')

    log.info("check success")
    if browser.find_by_text('Welcome to Rocket.Chat!'):
        log.info('success!')
    else:
        log.error('------------ERROR!!!!!------------')
        return

    if args_dict['all'] or not any(args_dict.values()):
        log.info('TESTING ALL BOTS...')
        bots = BOTS_FOR_TESTING
    else:
        bots = list(
            filter(lambda bot: args_dict[bot.__name__], BOTS_FOR_TESTING)
        )

    for bot in bots:
        log.info('TESTING {0} ...'.format(bot.__name__))
        result = bot.run_script(browser, log)
        if not result:
            log.error('------------SOMETHING WENT WRONG!!!------------')
            break
        log.info('TESTING {0} IS SUCCESSFULLY FINISHED'.format(bot.__name__))

    browser.quit()


parser = argparse.ArgumentParser(
    description='Choose what bots you want to test.')
parser.add_argument('-a', '--all', action='store_true',
                    help='run all tests.')
parser.add_argument('-b', '--happy_birthder', action='store_true',
                    help='run happy birthder test.')
args = parser.parse_args()
args_dict = vars(args)

load_dotenv()
main()
