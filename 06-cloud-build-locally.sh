#!/bin/bash

MODULE_TO_BUILD="${1:-app01}"
COLOR=${2:-orange}

# Created with codelabba.rb v.1.4a
source .env.sh || fatal 'Couldnt source this'
set -x
set -e

# Add your code here:
# docs for substitutions: https://cloud.google.com/build/docs/configuring-builds/substitute-variable-values
cloud-build-local --config="cloudbuild.yaml" --dryrun=false \
  --substitutions "_DEPLOY_UNIT=$MODULE_TO_BUILD,_REGION=$REGION,_ARTIFACT_REPONAME=$ARTIFACT_REPONAME" \
  --push apps/app01/









# End of your code here
verde Tutto ok.