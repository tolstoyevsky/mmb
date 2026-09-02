#!/bin/bash

set -e

PORT="${PORT:=8001}"

PM_MAX_CHILDREN=${PM_MAX_CHILDREN:=5}

PM_START_SERVERS=${PM_START_SERVERS:=2}

PM_MIN_SPARE_SERVERS=${PM_MIN_SPARE_SERVERS:=1}

PM_MAX_SPARE_SERVERS=${PM_MAX_SPARE_SERVERS:=3}

TYPE="${TYPE:=backend}"

change_ini_params() {
    change_ini_param.py --config-file /etc/php83/php-fpm.d/www.conf --section www "user" "nginx"

    change_ini_param.py --config-file /etc/php83/php-fpm.d/www.conf --section www "group" "nginx"

    change_ini_param.py --config-file /etc/php83/php-fpm.d/www.conf --section www "listen" "backend:9000"

    change_ini_param.py --config-file /etc/php83/php-fpm.d/www.conf --section www "clear_env" "no"

    change_ini_param.py --config-file /etc/php83/php-fpm.d/www.conf --section www "pm.max_children" "${PM_MAX_CHILDREN}"

    change_ini_param.py --config-file /etc/php83/php-fpm.d/www.conf --section www "pm.start_servers" "${PM_START_SERVERS}"

    change_ini_param.py --config-file /etc/php83/php-fpm.d/www.conf --section www "pm.min_spare_servers" "${PM_MIN_SPARE_SERVERS}"

    change_ini_param.py --config-file /etc/php83/php-fpm.d/www.conf --section www "pm.max_spare_servers" "${PM_MAX_SPARE_SERVERS}"

    change_ini_param.py --config-file /etc/php83/php.ini --section PHP "memory_limit" "512M"

    change_ini_param.py --config-file /etc/php83/php.ini --section PHP "apc.enable_cli" "1"
}

case "${TYPE}" in
frontend)
    sed -i -e "s/PORT/${PORT}/" /etc/nginx/http.d/default.conf

    /usr/sbin/nginx -g 'daemon off;'

    ;;
backend)
    change_ini_params

    if [[ ! -f /var/www/nc/config/config.php ]]; then
        touch /var/www/nc/config/CAN_INSTALL
        chown nginx:nginx -R /var/www/nc/config
        chown nginx:nginx -R /var/www/nc/data
    fi

    /usr/sbin/php-fpm83 --nodaemonize

    ;;
news_updater)
    change_ini_params

    sudo -u nginx nextcloud-news-updater /var/www/nc

    ;;
signaling)
    # Talk High Performance Backend signaling server.
    SIGNALING_SECRET="${SIGNALING_SECRET:=secret}"
    NATS_URL="${NATS_URL:=nats://nats:4222}"
    # Keys that sign the signaling session tokens. Random per start by default so
    # they are never a publicly known value; hashkey must be 32 or 64 bytes,
    # blockkey 16, 24 or 32 bytes. When running more than one signaling instance,
    # set SIGNALING_HASHKEY and SIGNALING_BLOCKKEY explicitly to the same value on
    # every instance (otherwise their tokens are not interchangeable).
    SIGNALING_HASHKEY="${SIGNALING_HASHKEY:-$(tr -dc 'a-f0-9' < /dev/urandom | head -c 64)}"
    SIGNALING_BLOCKKEY="${SIGNALING_BLOCKKEY:-$(tr -dc 'a-f0-9' < /dev/urandom | head -c 32)}"

    mkdir -p /etc/signaling

    # Only when the paired Nextcloud is served over TLS with a certificate the
    # signaling server does not trust (e.g. self-signed on an internal test
    # host): set SIGNALING_SKIP_VERIFY=true to skip backend TLS verification.
    # Left empty by default so production keeps strict certificate checking.
    SKIP_VERIFY=""
    if [ "${SIGNALING_SKIP_VERIFY:-false}" = "true" ]; then
        SKIP_VERIFY="skipverify = true"
    fi

    # Self-contained config (heredoc, no envsubst dependency in the image).
    # [backend] allowall=true with a single shared secret: the paired Nextcloud
    # authenticates every backend request with SIGNALING_SECRET, and the server
    # calls back to whatever base URL Nextcloud advertises (overwrite.cli.url),
    # so no per-instance URL needs to be baked in. Register the matching secret
    # with `occ talk:signaling:add <url> <SIGNALING_SECRET>`.
    # No [turn] section: it is only for the MCU path (which we do not run) and
    # the server refuses to start without a TURN API key when it is present.
    # TURN is delivered to clients by Talk itself (occ talk:turn:add).
    cat > /etc/signaling/server.conf <<EOF
[http]
listen = 0.0.0.0:8080

[sessions]
hashkey = ${SIGNALING_HASHKEY}
blockkey = ${SIGNALING_BLOCKKEY}

[backend]
allowall = true
secret = ${SIGNALING_SECRET}
${SKIP_VERIFY}

[nats]
url = ${NATS_URL}
EOF

    exec nextcloud-spreed-signaling -config /etc/signaling/server.conf

    ;;
nats)
    # Message bus for the signaling server.
    exec nats-server -a 0.0.0.0 -p 4222

    ;;
talk_provision)
    # One-shot: wire Talk to the High Performance Backend once Nextcloud is
    # installed. Idempotent, safe to re-run; only registers what is missing.
    # Runs as its own service (restart: "no") so it does not slow the backend.
    SIGNALING_URL="${SIGNALING_URL:=}"
    SIGNALING_SECRET="${SIGNALING_SECRET:=secret}"
    TURN_SERVER="${TURN_SERVER:=}"
    TURN_SECRET="${TURN_SECRET:=secret}"
    STUN_SERVER="${STUN_SERVER:=}"

    occ() { sudo -u nginx php83 /var/www/nc/occ "$@"; }

    # Wait for Nextcloud to be installed, but not forever: after the timeout give
    # up cleanly (exit 0) so `docker compose up` is not blocked. Re-running the
    # service (next `up`) picks up once the instance is installed.
    PROVISION_WAIT="${TALK_PROVISION_WAIT:=600}"
    >&2 echo "talk_provision: waiting up to ${PROVISION_WAIT}s for Nextcloud to finish installing ..."
    waited=0
    until occ status 2>/dev/null | grep -q "installed: true"; do
        if [ "${waited}" -ge "${PROVISION_WAIT}" ]; then
            >&2 echo "talk_provision: Nextcloud is not installed yet -- giving up for now, re-run once it is up"
            exit 0
        fi
        sleep 5
        waited=$((waited + 5))
    done

    occ app:enable spreed

    # External signaling server (delivered to clients as SIGNALING_URL, which
    # must be reachable from both the browsers and this server).
    if [ -n "${SIGNALING_URL}" ]; then
        if occ talk:signaling:list 2>/dev/null | grep -qF "${SIGNALING_URL}"; then
            >&2 echo "talk_provision: signaling server already registered"
        else
            occ talk:signaling:add "${SIGNALING_URL}" "${SIGNALING_SECRET}" ${SIGNALING_VERIFY:+--verify}
        fi
    else
        >&2 echo "talk_provision: SIGNALING_URL is empty -- set it to the public signaling URL (.../standalone-signaling/); skipping"
    fi

    # TURN via time-limited REST credentials (shared secret with coturn).
    if [ -n "${TURN_SERVER}" ]; then
        if occ talk:turn:list 2>/dev/null | grep -qF "${TURN_SERVER}"; then
            >&2 echo "talk_provision: TURN server already registered"
        else
            occ talk:turn:add turn "${TURN_SERVER}" udp,tcp --secret "${TURN_SECRET}"
        fi
    else
        >&2 echo "talk_provision: TURN_SERVER is empty -- skipping TURN"
    fi

    # STUN.
    if [ -n "${STUN_SERVER}" ]; then
        if occ talk:stun:list 2>/dev/null | grep -qF "${STUN_SERVER}"; then
            >&2 echo "talk_provision: STUN server already registered"
        else
            occ talk:stun:add "${STUN_SERVER}"
        fi
    else
        >&2 echo "talk_provision: STUN_SERVER is empty -- skipping STUN"
    fi

    >&2 echo "talk_provision: done"

    ;;
*)
    >&2 echo "Unknown ${TYPE} service type"
    exit 1
    ;;
esac

