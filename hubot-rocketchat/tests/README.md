README

Dependencies:
- python3
- virtualenv

Setup:
- Need fill .env file next data:
  - SIGN_IN_USERNAME=
  - SIGN_IN_PASSWORD=
  - USER_NAME=
  - USER_USERNAME=
  - USER_EMAIL=
  - USER_PASSWORD=
- ./setup.sh

Help:
- ./test_hubots_bots.py -h (--help)

Launch:
- run test all bots:
  - ./test_hubots_bots.py
  - ./test_hubots_bots.py -a (--all)
- run test happy birthder:
  - ./test_hubots_bots.py -b (--happy_birthder)
