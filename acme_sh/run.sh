#!/usr/bin/with-contenv bashio

ACCOUNT=$(bashio::config 'account')
SERVER=$(bashio::config 'server')
DOMAINS=$(bashio::config 'domains')
KEYFILE=$(bashio::config 'keyfile')
CERTFILE=$(bashio::config 'certfile')
DNS_PROVIDER=$(bashio::config 'dns.provider')
DNS_ENVS=$(bashio::config 'dns.env')
OPTIONS=$(bashio::config 'options')


for env in $DNS_ENVS; do
    export $env
done

DOMAIN_ARR=()
for domain in $DOMAINS; do
    DOMAIN_ARR+=(--domain "$domain")
done

SERVER_ARG="zerossl"
if [ -n "$SERVER" ]; then
    SERVER_ARG="--server $SERVER"
fi

OPTIONS_ARG=" "
if [ -n "$OPTIONS" ]; then
    OPTIONS_ARG="$OPTIONS"
fi

/root/.acme.sh/acme.sh --register-account -m ${ACCOUNT} $SERVER_ARG

/root/.acme.sh/acme.sh --issue "${DOMAIN_ARR[@]}" \
--dns "$DNS_PROVIDER" \
 $OPTIONS_ARG $SERVER_ARG

/root/.acme.sh/acme.sh --install-cert "${DOMAIN_ARR[@]}" \
--fullchain-file "/ssl/${CERTFILE}" \
--key-file "/ssl/${KEYFILE}" \

tail -f /dev/null
