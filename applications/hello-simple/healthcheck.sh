#!/bin/bash

PUBLIC_ENDPOINT="http://${PUBLIC_ADDRESS}"
TEXT_TO_CHECK='My Private IP is'

# Create retry function
function retry {
  while :
  do
    STATUSCODE=$(curl -L -o /dev/null -s -w "%{http_code}\n" -k "${@}")
    if [[ "$STATUSCODE" -ne "000" && "$STATUSCODE" -eq "200" ]] 
    then
      RESPONSE=$(curl -L -k -s "${@}")
      if [[ "$RESPONSE" == *"$TEXT_TO_CHECK"* ]]
      then
        echo "External ALB ${@} is healthy and has valid text. Statuscode: ${STATUSCODE}" && break
      fi
        echo "External ALB ${@} is healthy but has invalid text. Statuscode: ${STATUSCODE}" && exit 1
    fi
      echo "External ALB ${@} is unhealthy. Statuscode: ${STATUSCODE}" && sleep 20
  done
}


for ALB in $PUBLIC_ENDPOINT;
do
  retry $ALB
done
