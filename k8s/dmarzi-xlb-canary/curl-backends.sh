#!/bin/bash

DEFAULT_IP="34.149.231.48"
IP=${1:-$DEFAULT_IP}


#echo -en 'Autoinferring IP would yield this: '
#gcloud compute forwarding-rules list | grep gkegw | awk '{print $2}' | xargs | lolcat 
echo "1. For your curiosity, these are the current Load Balancers surfaced by GKE Gateway construct:"
gcloud compute forwarding-rules list | grep gkegw | awk '{print $2}' | xargs | lolcat 

function _oneoff_setup_dns() {
#      - "store-bifido.palladius.it"
# This works for Carlesso only:
    RICC_SERVICE_IP="$(gcloud compute forwarding-rules list | grep gkegw  | grep ricc-external-store | awk '{print $2}' )"
    dns-setup-palladius.sh ricc-store.palladius.it "$RICC_SERVICE_IP"
    RICC_SERVICE_IP2="$(gcloud compute forwarding-rules list | grep gkegw  | grep default-bifid-external-store | awk '{print $2}' )"
    dns-setup-palladius.sh store-bifido.palladius.it "$RICC_SERVICE_IP2"

    #gcloud --quiet --project RICPROJECT beta dns record-sets create --rrdatas='34.117.142.130' --type=A --ttl=300 --zone=palladius-it ricc-store.palladius.it
    #gcloud --quiet --project RICPROJECT beta dns record-sets create --rrdatas='34.117.59.54' --type=A --ttl=300 --zone=palladius-it store-bifido.palladius.it
}
function _curl() {
    curl "$@" 2>/dev/null
}
set -x 

echo "2. curling Ricc Services:"
#RICC_SERVICE_IP="$(gcloud compute forwarding-rules list | grep gkegw  | grep ricc-external-store | awk '{print $2}' )"

#curl -H "host: ricc-store.palladius.it" "http://$RICC_SERVICE_IP/"
#curl http://ricc-store.palladius.it 2>/dev/null
_curl http://ricc-store.palladius.it/storev1 
_curl http://ricc-store.palladius.it/storev2 

echo "3. _curling Bifid Services (/v1 /v2 , while / is both):"
_curl http://store-bifido.palladius.it/ 
_curl http://store-bifido.palladius.it/v1/ 
_curl http://store-bifido.palladius.it/v2/ 

echo THE END.

