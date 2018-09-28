#!/usr/bin/env python3
import os

from dotenv import load_dotenv
from splinter import Browser

from base import logging
import test_happy_birthder

load_dotenv()


BROWSER_WINDOW_SIZE = (1920, 1080)

log = logging()
browser = Browser('chrome', headless=False, wait_time=30,
                  executable_path='./drivers/chromedriver')


def main():
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

    # ToDo (if ...) look optparse!
    log.info('------------run test happy birthder------------')
    test_happy_birthder.run_script(browser, log)

    # ToDo ... optparse and run other scripts!

    browser.quit()


main()
