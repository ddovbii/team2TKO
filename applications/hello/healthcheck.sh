#!/bin/bash

PUBLIC_ENDPOINT="http://${PUBLIC_ADDRESS}"
TEXT_TO_CHECK='My Private IP is'

# Create retry function
function retry {
  while :
  do
    RESPONSE=$(curl -k "${@}")
    STATUSCODE=$(curl -o /dev/null -s -w "%{http_code}\n" -k "${@}")
    if [[ "$STATUSCODE" -ne "000" && "$STATUSCODE" -eq "200" ]] 
    then
      if [[ "$RESPONSE" == *"$TEXT_TO_CHECK"* ]]
      then
      echo "External ALB ${@} is healthy and has valid text. Statuscode: ${STATUSCODE}" && break
      fi
      echo "External ALB ${@} is healthy but has invalid text. Statuscode: ${STATUSCODE}" && return exit 1
    fi
      echo "External ALB ${@} is unhealthy. Statuscode: ${STATUSCODE}" && sleep 20
  done
}


for ALB in $PUBLIC_ENDPOINT;
do
  retry $ALB
done
