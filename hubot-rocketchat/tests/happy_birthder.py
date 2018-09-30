#!/usr/bin/env python3
import os

from dotenv import load_dotenv

from base import create_user, remove_user, click_send_btn_and_get_last_msg

load_dotenv()

BOT_NAME = 'meeseeks'
USERNAME = os.getenv('USER_USERNAME')
FULL_USER_BIRTHDAY = '01.01.2000'
USER_BIRTHDAY = '01.01'


def check_result(browser, log, last_msg, expected_msg):
    if last_msg.text != expected_msg:
        log.error('------------ERROR!!!!!------------')
        log.info('removing user...')
        remove_user(browser, log)
        return False
    return True


def run_script(browser, log):
    log.info('creating user...')
    result = create_user(browser, log)
    if not result:
        return False

    log.info('Click general chat')
    general_chat = browser.driver.find_elements_by_css_selector(
        'div.sidebar-item__ellipsis'
    )[0]
    general_chat.click()
    log.info('success!')

    # ToDo Need try it!
    """
    from selenium.webdriver.support.ui import WebDriverWait
    ...
    ...
    def find(driver):
        element = driver.find_elements_by_id("data")
        if element:
            return element
        else:
            return False
    element = WebDriverWait(driver, secs).until(find)
    """

    log.info('Send birthday set request')
    browser.fill('msg', '{0} birthday set {1} {2}'
                 .format(BOT_NAME, USERNAME, FULL_USER_BIRTHDAY))
    last_msg = click_send_btn_and_get_last_msg(browser)
    log.info(last_msg.text)  # ToDo remove
    expected_msg = "Saving {0}'s birthday.".format(USERNAME)
    if not check_result(browser, log, last_msg, expected_msg):
        return False
    log.info('success!')

    log.info('Send birthdays on request')
    browser.fill('msg', '{0} birthdays on {1}'.format(BOT_NAME, USER_BIRTHDAY))
    last_msg = click_send_btn_and_get_last_msg(browser)
    expected_msg = "@{0}".format(USERNAME)
    if not check_result(browser, log, last_msg, expected_msg):
        return False
    log.info('success!')

    log.info('Send birthdays list request')
    browser.fill('msg', '{0} birthdays list'.format(BOT_NAME))
    last_msg = click_send_btn_and_get_last_msg(browser)
    log.info(last_msg.text)  # ToDo remove
    expected_msg = "@{0} was born on {1}".format(USERNAME, FULL_USER_BIRTHDAY)
    if not check_result(browser, log, last_msg, expected_msg):
        return False
    log.info('success!')

    log.info('Send birthday delete request')
    browser.fill('msg', '{0} birthday delete {1}'.format(BOT_NAME, USERNAME))
    last_msg = click_send_btn_and_get_last_msg(browser)
    log.info(last_msg.text)  # ToDo remove
    expected_msg = "Removing {0}'s birthday.".format(USERNAME)
    if not check_result(browser, log, last_msg, expected_msg):
        return False
    log.info('success!')

    log.info('Send birthdays list request again')

    log.info('success!')

    log.info('removing user...')
    result = remove_user(browser, log)
    if not result:
        return False

    return True
