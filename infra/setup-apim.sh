#!/bin/bash

set -e

names=("SmsApp" "SmsVerificationApp")

#'dev', 'test', 'prod', 'kdy', 'kms', 'lsw', 'pjm'
environment=$1

version=$(curl -H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/devrel-kr/nhn-toast-notification-service-custom-connector/releases/latest| \
jq '.tag_name' -r)

urls=$(curl -H "Accept: application/vnd.github.v3+json" \
https://api.github.com/repos/devrel-kr/nhn-toast-notification-service-custom-connector/releases/latest| \
jq '.assets[] | { name: .name, url: .browser_download_url }')

for name in ${names[@]}
do
    filename="$name-$version.zip"
    smszip=$(echo $urls | jq --arg v $filename 'select(.name == $v) | .url' -r)
    if [ $name == "SmsApp" ]
    then
        fncappName="fncapp-nt-sms-$environment-krc"
    elif [ $name == "SmsVerificationApp" ]
    then 
        fncappName="fncapp-nt-sms-verify-$environment-krc"
    fi
    fncappUrl="https://$fncappName.azurewebsites.net/api/openapi/v3.json"
    smsapp=$(az functionapp deploy -g rg-nt-$environment-krc -n $fncappName --src-url $smszip --type zip)
    az deployment group create -n ApiManagement_Api-$name -g rg-nt-$environment-krc -u https://raw.githubusercontent.com/devrel-kr/nhn-toast-notification-service-custom-connector/main/infra/provision-apiManagementApi.json -p name=nt -p env=$environment -p apiMgmtNameValueName=apiMgmtNameValueName -p apiMgmtNameValueDisplayName=apiMgmtNameValueDisplayName -p apiMgmtNameValueValue=apiMgmtNameValueValue -p apiMgmtApiName=apiMgmtApiName -p apiMgmtApiDisplayName=apiMgmtApiDisplayName -p apiMgmtApiDescription=apiMgmtApiDescription -p apiMgmtApiPath=apiMgmtApiPath -p apiMgmtApiValue=$fncappUrl
done