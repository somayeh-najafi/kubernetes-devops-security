#! /bin/bash

PORT=$(kubectl -n default get svc ${serviceName} -o json | jq .spec.ports[].nodePort)

docker run -t -v "\$(pwd):/zap/wrk/:rw" owasp/zap2docker-weekly zap-api-scan.py -t $applicationURL:$PORT/v3/api-docs -f openapi -r zap_report.html
exit_code=$?

sudo mkdir -p owasp-zap-report
sudo mv zap_report.html owasp-zap-report
echo "exit_code: $exit_code"
if [[ $exit_code -ne 0  ]]; then
    echo "OWASP ZAP Rport has either low/meduim/high risk. Please check the html report."
    exit 1;
else
    echo "OWASP ZAP did not report any risk"
fi;