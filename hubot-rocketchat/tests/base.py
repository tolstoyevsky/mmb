#!/usr/bin/env python3
import os
import sys

from logbook import Logger, StreamHandler


def logging():
    StreamHandler(sys.stdout).push_application()
    return Logger('LOCALDEV')


def create_user(browser, log):
    log.info('Click options button')
    options_btn = browser.find_by_css(
        '.sidebar__toolbar-button.rc-tooltip.rc-tooltip--down.js-button'
    )
    options_btn.last.click()
    log.info('success!')

    log.info('Click administration button')
    administration_btn = browser.find_by_css('.rc-popover__item-text')
    administration_btn.click()
    log.info('success!')

    log.info('Click users button')
    users_btn = browser.driver.find_elements_by_css_selector(
        'a.sidebar-item__link[aria-label="Users"]'
    )[0]
    browser.driver.execute_script("arguments[0].click();", users_btn)
    log.info('success!')

    log.info('Click add user button')
    add_user_btn = browser.find_by_css('button[aria-label="Add User"]')
    add_user_btn.click()
    log.info('success!')

    log.info('Fill name field')
    input_name_el = browser.find_by_css('input#name').first
    input_name_el.fill(os.getenv('USER_NAME'))
    log.info('success!')

    log.info('Fill username field')
    input_username_el = browser.find_by_css('input#username').first
    input_username_el.fill(os.getenv('USER_USERNAME'))
    log.info('success!')

    log.info('Fill email field')
    input_email_el = browser.find_by_css('input#email').first
    input_email_el.fill(os.getenv('USER_EMAIL'))
    log.info('success!')

    log.info('Click verify switch button')
    verified_btn = browser.find_by_css('label.rc-switch__label').first
    verified_btn.click()
    log.info('success!')

    log.info('Fill password')
    input_password_el = browser.find_by_css('input#password').first
    input_password_el.fill(os.getenv('USER_PASSWORD'))
    log.info('success!')

    log.info('Click require switch button')
    verified_btn = browser.find_by_css('label.rc-switch__label').last
    verified_btn.click()
    log.info('success!')

    log.info('Choose role')
    role_option = browser.find_by_css('option[value="bot"]').first
    role_option.click()
    add_role_btn = browser.find_by_css('button#addRole').first
    add_role_btn.click()
    log.info('success!')

    log.info('Unclick "send welcome email" checkbox')
    welcome_ckbx = browser.find_by_css('label[for="sendWelcomeEmail"]').first
    welcome_ckbx.click()
    log.info('success!')

    log.info('Click save button')
    save_btn = browser.find_by_css('.rc-button.rc-button--primary.save').first
    save_btn.click()
    log.info('success!')

    log.info('Click close button')
    close_btn = browser.find_by_css('button[data-action="close"]').first
    close_btn.click()
    log.info('success!')


def remove_user(browser, log):
    log.info('Click options button')
    options_btn = browser.driver.find_elements_by_css_selector(
        '.sidebar__toolbar-button.rc-tooltip.rc-tooltip--down.js-button'
    )[-1]
    browser.driver.execute_script("arguments[0].click();", options_btn)
    log.info('success!')

    log.info('Click administration button')
    administration_btn = browser.find_by_css('.rc-popover__item-text')
    administration_btn.click()
    log.info('success!')

    log.info('Click users button')
    users_btn = browser.driver.find_elements_by_css_selector(
        'a.sidebar-item__link[aria-label="Users"]'
    )[0]
    browser.driver.execute_script("arguments[0].click();", users_btn)
    log.info('success!')

    log.info('Click to selected user')
    selected_user = browser.find_by_xpath(
        '//td[@class="border-component-color"]'
        '[text()="{0}"]'.format(os.getenv('USER_USERNAME'))
    ).first
    selected_user.click()
    log.info('success!')

    log.info('Click to "more" button')
    more_btn = browser.find_by_css(
        'button.rc-tooltip.rc-room-actions__button.js-more'
        '[aria-label="More"]'
    ).first
    more_btn.click()
    log.info('success!')

    log.info('Click to delete button')
    delete_btn = browser.find_by_xpath(
        '//li[@class="rc-popover__item js-action"]'
        '/span[text()="Delete"]'
    ).first
    delete_btn.click()
    confirm_btn = browser.find_by_css('input[value="Yes, delete it!"]').first
    confirm_btn.click()
    log.info('success!')

    log.info('Click close button')
    close_btn = browser.driver.find_elements_by_css_selector(
        'button[data-action="close"]'
    )[0]
    browser.driver.execute_script("arguments[0].click();", close_btn)
    log.info('success!')


def click_send_btn_and_get_last_msg(browser):
    send_msg_btn = browser.find_by_css(
        'svg.rc-icon.rc-input__icon-svg.rc-input__icon-svg--send'
    ).first
    send_msg_btn.click()

    last_msg = browser.driver.find_elements_by_css_selector(
        'div.body.color-primary-font-color '
    )[-1]
    return last_msg
