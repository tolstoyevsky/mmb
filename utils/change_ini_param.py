#!/usr/bin/env python3
# Copyright 2018 Evgeny Golyshev. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Utility intended for editing configuration files in INI format. """

import configparser
import sys
from optparse import OptionParser
from pathlib import Path


MY_CNF = '/etc/mysql/my.cnf'

SECTION = 'mysqld'


def main():
    """The main entry point. """

    parser = OptionParser(usage='usage: %prog [options] option value')
    parser.add_option('--config-file', default=MY_CNF,
                      help='Path to configuration file', metavar='CONFIG_FILE')
    parser.add_option('--section', default=SECTION,
                      help='Section name which the specified option '
                           'belongs to',
                      metavar='SECTION')
    options, args = parser.parse_args()

    if len(args) != 2:
        sys.stderr.write('Usage: {} option value\n'.format(sys.argv[0]))
        sys.exit(1)

    if not Path(options.config_file).is_file():
        sys.stderr.write('{} does not exist\n'.format(options.config_file))
        sys.exit(1)

    config = configparser.ConfigParser(allow_no_value=True)

    # Preserve case
    config.optionxform = str

    config.read(options.config_file, encoding='utf-8')

    config.set(options.section, args[0], args[1])

    with open(options.config_file, 'w') as configfile:
        config.write(configfile)


if __name__ == '__main__':
    main()
