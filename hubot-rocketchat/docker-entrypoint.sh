#!/bin/bash

to_be_added_to_external_scripts=""

for script in ${EXTERNAL_SCRIPTS//,/ }; do
    if [[ "${script}" == git:* ]]; then
        # without 'git:'
        script="${script:4}"

        >&2 echo "Installing ${script} from Git"

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

    else
        >&2 echo "Installing ${script} from NPM registry"

        npm install "${script}"
    fi

    to_be_added_to_external_scripts="${to_be_added_to_external_scripts},${script}"
done

# strip ','
to_be_added_to_external_scripts="${to_be_added_to_external_scripts:1}"

node -e "console.log(JSON.stringify('${to_be_added_to_external_scripts}'.split(',')))" > external-scripts.json

bin/hubot -n "${BOT_NAME}" -a rocketchat

