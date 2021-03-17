#!/bin/bash

ALB_STS="https://cst${SANDBOX_ID}.${domain_name}/STS"
ALB_InformRMS="https://cst${SANDBOX_ID}.${domain_name}/InformRMS"
# ALB_InformRMSHost="https://cst${SANDBOX_ID}.${domain_name}/InformRMSHost"
# ALB_optimus="https://cst${SANDBOX_ID}.${domain_name}/optimus"


# Create retry function
function retry {
  while :
  do
    STATUSCODE=$(curl -o /dev/null -s -w "%{http_code}\n" -k "${@}")
    if [[ "$STATUSCODE" -ne "000" && "$STATUSCODE" -le "399" ]] 
    then
      echo "External ALB ${@} is healthy. Statuscode: ${STATUSCODE}" && break
    fi
      echo "External ALB ${@} is unhealthy. Statuscode: ${STATUSCODE}" && sleep 20
  done
}


for ALB in $ALB_STS $ALB_InformRMS; # $ALB_InformRMSHost $ALB_optimus
do
  retry $ALB
done
