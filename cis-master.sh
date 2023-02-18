#! /bin/bash

total_fail=$(kube-bench run --targets master --version 1.15 --check 1.2.21,1.2.23,1.2.24 --json | jq .total_fail)

if [[ "$total_fail" -ne 0 ]];
    then
        echo "CIS Benchmark Failed Kubelet while testing for 1.2.21 , 1.2.23 , 1.2.24"
        exit 1;

else
        echo "CIS Benchmark Passed Kubelet while testing for 1.2.21 , 1.2.23 , 1.2.24"
fi;
