#! /bin/bash
sleep 60
if [[ $(kubectl -n prod rollout status deployment ${deploymentName} --timeout 5s) != *"successfully rolled out"*  ]]; then
 echo "Deployment ${deploymentName} rollout failed."
 kubectl -n prod rollout undo deployment ${deploymentName}
 exit 1;
else
 echo "Deployment ${deploymentName} rolled out successfully"
fi