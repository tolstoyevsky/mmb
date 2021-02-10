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

import argparse
import configparser
import sys
from pathlib import Path


MY_CNF = '/etc/mysql/my.cnf'

SECTION = 'mysqld'


def main():
    """The main entry point. """

    parser = argparse.ArgumentParser(usage='usage: %(prog)s [options] option value')
    parser.add_argument('--config-file', default=MY_CNF,
                        help='Path to configuration file', metavar='CONFIG_FILE')
    parser.add_argument('--section', default=SECTION,
                        help='Section name which the specified option belongs to',
                        metavar='SECTION')
    parser.add_argument('param', help='Configuration parameter',
                        metavar='PARAM')
    parser.add_argument('value', help='Configuration parameter value',
                        metavar='VALUE')
    args = parser.parse_args()

    if not Path(args.config_file).is_file():
        sys.stderr.write('{} does not exist\n'.format(args.config_file))
        sys.exit(1)

    config = configparser.ConfigParser(allow_no_value=True)

    # Preserve case
    config.optionxform = str

    config.read(args.config_file, encoding='utf-8')

    config.set(args.section, args.param, args.value)

    with open(args.config_file, 'w') as configfile:
        config.write(configfile)


if __name__ == '__main__':
    main()
