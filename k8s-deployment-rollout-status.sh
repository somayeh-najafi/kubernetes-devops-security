#! /bin/bash
sleep 60
if [[ $(kubectl -n default rollout status deployment ${deploymentName} --timeout 5s) != "successfully rolled out" ]]; then
 echo "Deployment ${deploymentName} rollout failed."
 kubectl -n default rollout undo deployment ${deploymentName}
 exit 1;
else
 echo "Deployment ${deploymentName} rolled out successfully"
fi