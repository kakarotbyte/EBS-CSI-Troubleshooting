#!/bin/bash

# Await cluster activation
aws eks wait cluster-active --name ebs-demo-1

# Check exit status of the previous command
if [[ $? -eq 0 ]]; then
    # Cluster is active, proceed with subsequent commands
    echo "Cluster is active. Continuing with further actions..."

    # Place your additional commands here
    # Example:
    # kubectl apply -f my-deployment.yaml
else
    echo "Cluster activation failed. Exiting script."
    exit 1
fi
