#!/usr/bin/env sh

ORGANIZATION=${1:-${TASKD_ORGANIZATION}}
USERNAME=${2:-${TASKD_USERNAME}}
TARGET_FILENAME=${3:-client}
TARGET_PATH=${4:-${CLIENT_CERT_PATH}}

echo "Generate ${USERNAME}"

# @todo test if org already exists ?
taskd add org ${TASKD_ORGANIZATION}
UID=$(taskd add user "${TASKD_ORGANIZATION}" "${TASKD_USERNAME}" | grep 'key' | cut -d' ' -f 4)

cd ${TASKDDATA}/pki
./generate.client user_client

CREDENTIALS="${TASKD_ORGANIZATION}/${TASKD_USERNAME}/${UID}"

echo "Generated credentials: ${CREDENTIALS}"

echo ${CREDENTIALS} > ${CLIENT_CERT_PATH}/${TARGET_FILENAME}.credentials
cp user_client.cert.pem ${CLIENT_CERT_PATH}/${TARGET_FILENAME}.cert.pem
cp user_client.key.pem ${CLIENT_CERT_PATH}/${TARGET_FILENAME}.key.pem
cp ca.cert.pem ${CLIENT_CERT_PATH}/

echo "Certificate files in ${CLIENT_CERT_PATH}:"
ls ${CLIENT_CERT_PATH}/
