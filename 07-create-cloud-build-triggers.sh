#!/bin/bash

# Created with codelabba.rb v.1.4a
source .env.sh || fatal 'Couldnt source this'
#set -x
set -e

# Add your code here:

# array: https://stackoverflow.com/questions/12317483/array-of-arrays-in-bash
# TeamNumber ; TeamName ; CloudBuild file ; Source To Be listening
TEAMS[0]='T1py;app01;cloudbuild.yaml;apps/app01/;blue'
TEAMS[1]='T2rb;app02;cloudbuild.yaml;apps/app02/;green'
#TEAMS[2]='T3;frontend;cloudbuild-super-parametric.yaml;src/frontend/;yellow'
#TEAMS[3]='T4;loadgenerator;cloudbuild-super-parametric.yaml;src/loadgenerator/;red'

TRIGGERVERSION="1-3"
# 1.2 Made better substitutions.
# 1.3 Made from regional to GLOBAL

touch /tmp/MyEmptyFile

GCR_REPO="palladius/clouddeploy-platinum-path"
GITHUB_REPO_NAME="clouddeploy-platinum-path"
GITHUB_REPO_OWNER="palladius"

for TEAM_ARR in "${TEAMS[@]}"; do
    IFS=";" read -r -a arr <<< "${TEAM_ARR}"

    TEAM_NUMBER="${arr[0]}"
    TEAM_NAME="${arr[1]}"
    BUILD_FILE="${arr[2]}"
    SRC_SUBFOLDER="${arr[3]}"
    FAV_COLOR="${arr[4]}"

    #gray $TEAMS
    gsutil cp /tmp/MyEmptyFile gs://$SKAFFOLD_BUCKET/skaffold-cache/$TEAM_NAME.txt

    SUBSTIUTIONS="_DEPLOY_UNIT=$TEAM_NAME,_REGION=$REGION,_ARTIFACT_REPONAME=$ARTIFACT_REPONAME"

    # This sets up on GCR
    gcloud alpha builds triggers create github --repo-owner="$GITHUB_REPO_OWNER" --repo-name="$GITHUB_REPO_NAME" --branch-pattern='.*' \
      --description="[$TEAM_NUMBER] CB trigger from CLI for $TEAM_NAME module" --included-files="${SRC_SUBFOLDER}**,*.yaml" \
      --build-config cloudbuild.yaml --substitutions="$SUBSTIUTIONS" \
      --name $TEAM_NUMBER-CLIv$TRIGGERVERSION-$TEAM_NAME
    # echo NOT_THIS gcloud alpha builds triggers create cloud-source-repositories --repo=palladius/clouddeploy-platinum-path --branch-pattern='.*' \
    #   --description="[$TEAM_NUMBER] CB trigger from CLI for $TEAM_NAME module" --included-files="${SRC_SUBFOLDER}**,*.yaml" \
    #   --build-config cloudbuild.yaml --substitutions="_DEPLOY_UNIT=$TEAM_NAME,_FAVORITE_COLOR=$FAV_COLOR" \
    #   --region=$REGION --name $TEAM_NUMBER-CLIv$TRIGGERVERSION-$TEAM_NAME

done

# End of your code here
verde Tutto ok.