#! /bin/bash

sleep 5s

#PORT=$(kubectl -n prod get svc ${serviceName} -o json | jq .spec.ports[].nodePort)
PORT=$(kubectl -n istio-system get svc istio-ingressgateway -o json | jq '.spec.ports[] | select(.port == 80)' | jq .nodePort)

echo $PORT
echo $applicationURL
echo $applicationURI
echo $applicationURL:$PORT/$applicationURI

if [[ ! -z $PORT ]]; then
    response=$(curl -s $applicationURL:$PORT/$applicationURI)
    http_code=$(curl -s -o /dev/null -w "%{http_code}" ${applicationURL}:$PORT/${applicationURI})

    if [[ $response == 100 ]];
        then
            echo "Increment Test Passed"
        else
            echo "Increment Test Failed"
            exit 1;
    fi;
    if [[ $http_code == 200 ]]; then
        echo "http status code test passed"
    else
        echo "http status code test failed"
        exit 1;
    fi;
else
    echo "Te service doesn't have nodePort assigneed."
    exit 1;
fi;