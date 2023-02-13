#! /bin/bash

sleep 5s

PORT=$(kubectl -n default get svc ${serviceName} -o json | jq .spec.ports[].nodePort)

echo $PORT
echo $applicatinURL
echo $applicationURI
echo $applicatinURL:$PORT/$applicationURI

if [[ ! -z $PORT ]]; then
    response=$(curl -s $applicatinURL:$PORT/$applicationURI)
    http_code=$(curl -s -o /dev/null -w "%{http_code}" ${applicatinURL}:$PORT/${applicationURI})

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