#!/bin/bash

set -x

AUTH_ATTEMPTS=${AUTH_ATTEMPTS:=60}

DEBUG=${DEBUG:=false}

REQUIRED_PRIVATE_CHANNELS=${REQUIRED_PRIVATE_CHANNELS=""}

ROCKETCHAT_URL=${ROCKETCHAT_URL:="http://rocketchat:8006"}

ROCKETCHAT_ROOM=${ROCKETCHAT_ROOM:=""}

ROCKETCHAT_USER=${ROCKETCHAT_USER:="meeseeks"}

ROCKETCHAT_PASSWORD=${ROCKETCHAT_PASSWORD:="pass"}

EXTERNAL_SCRIPTS=${EXTERNAL_SCRIPTS:="git:tolstoyevsky/hubot-happy-birthder,git:tolstoyevsky/hubot-help,git:tolstoyevsky/hubot-pugme,hubot-reaction,git:hubotio/hubot-redis-brain,hubot-thesimpsons,git:tolstoyevsky/hubot-vote-or-die"}

HUBOT_NAME=${HUBOT_NAME:="bot"}

LISTEN_ON_ALL_PUBLIC=${LISTEN_ON_ALL_PUBLIC:=true}

RESPOND_TO_DM=${RESPOND_TO_DM:=true}

TZ=${TZ:="Europe/Moscow"}

# hubot-redis-brain script
REDIS_URL=${REDIS_URL:="redis:///var/run/hubot-redis.sock"}

set +x

to_be_added_to_external_scripts=""

for script in ${EXTERNAL_SCRIPTS//,/ }; do
    if [[ "${script}" == git:* ]]; then
        # without 'git:'
        script="${script:4}"

        >&2 echo "Installing ${script} from the GitHub repo"

	username_repo=(${script/\// })

	if [ ${#username_repo[@]} -ne 2 ]; then
            >&2 echo "The script specified with the 'git:' prefix must follow the format: usename/repo"
            exit 1
        fi

	repo_branch=(${username_repo[1]/@/ })
	if [ ${#repo_branch[@]} -ne 2 ]; then
            npm install https://github.com/"${username_repo[0]}"/"${username_repo[1]}".git

            # will be added to external-scripts.json
            script="${username_repo[1]}"
        else
            src=node_modules/"${username_repo[0]}"/"${repo_branch[0]}"

            mkdir -p "${src}"

            git clone -b "${repo_branch[1]}" https://github.com/"${username_repo[0]}"/"${repo_branch[0]}".git "${src}"

            npm install "${src}"

            # will be added to external-scripts.json
            script="${repo_branch[0]}"
        fi
    elif [[ "${script}" == dir:* ]]; then
        # without 'dir:'
        script="${script:4}"
        package="/root/hubot/packages/${script}"

        >&2 echo "Installing ${script} from the /root/hubot/packages directory"

        if [ ! -d "${package}" ]; then
            >&2 echo "The specified package ${script} does not exist in the /root/hubot/packages directory"
            exit 1
        fi

        npm install "${package}"
    else
        >&2 echo "Installing ${script} from NPM registry"

        npm install "${script}"
    fi

    to_be_added_to_external_scripts="${to_be_added_to_external_scripts},${script}"
done

>&2 echo "Checking if ${ROCKETCHAT_USER} account is available"
result=false
for i in $(seq ${AUTH_ATTEMPTS} ${END}); do
    json=$(curl ${ROCKETCHAT_URL}/api/v1/login --silent -d "user=${ROCKETCHAT_USER}&password=${ROCKETCHAT_PASSWORD}")
    if [ ! -z "${json}" ]; then
        status=$(node -e "console.log(JSON.parse('${json}').status)")
        if [ "${status}" == "success" ]; then
            result=true
            break
        fi
    fi
    sleep 1
done

if ! ${result}; then
    >&2 echo "${ROCKETCHAT_USER} account is not available"
    exit 1
fi

>&2 echo "${ROCKETCHAT_USER} account is available"

if [ ! -z "${REQUIRED_PRIVATE_CHANNELS}" ]; then
    token=$(node -e "console.log(JSON.parse('${json}').data.authToken)")
    user_id=$(node -e "console.log(JSON.parse('${json}').data.userId)")

    >&2 echo "Checking if ${ROCKETCHAT_USER} is in required channels"

    for i in $(seq ${AUTH_ATTEMPTS} ${END}); do
        groups=$(curl --silent -H "X-Auth-Token: ${token}" -H "X-User-Id: ${user_id}" ${ROCKETCHAT_URL}/api/v1/groups.list)

        includes=$(node -e "console.log('${REQUIRED_PRIVATE_CHANNELS}'.split(',').every(g => JSON.parse('${groups}').groups.map(g => g.name).includes(g)))")

        if ${includes}; then
            break
        fi

        sleep 1
    done

    if ! ${includes}; then
        >&2 echo "${ROCKETCHAT_USER} is not in required channels"
        exit 1
    fi

    >&2 echo "${ROCKETCHAT_USER} is in required channels"
fi

# strip ','
to_be_added_to_external_scripts="${to_be_added_to_external_scripts:1}"

node -e "console.log(JSON.stringify('${to_be_added_to_external_scripts}'.split(',')))" > external-scripts.json

npm install
export PATH="/usr/lib/node_modules/hubot/bin:/usr/local/share/npm/bin:/root/hubot/node_modules/hubot/bin:$PATH"

if ${DEBUG}; then
    coffee --nodejs --inspect hubot -n "${BOT_NAME}" -a rocketchat "$@"
else
    exec hubot -n "${BOT_NAME}" -a rocketchat "$@"
fi
