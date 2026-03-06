#!/bin/bash

echo "Creating namespaces..."
kubectl apply -f .infrastructure/namespace.yml

sleep 2

echo "Applying Secrets and ConfigMaps..."
kubectl apply -f .infrastructure/st-secret.yml
kubectl apply -f .infrastructure/st-config.yml
kubectl apply -f .infrastructure/secret.yml
kubectl apply -f .infrastructure/confgiMap.yml # У тебе в файлах була помилка в назві: confgiMap.yml

sleep 2

echo "Setting up storage..."
kubectl apply -f .infrastructure/pv.yml
kubectl apply -f .infrastructure/pvc.yml

sleep 5

echo "Deploying MySQL StatefulSet..."
kubectl apply -f .infrastructure/st-service.yml
kubectl apply -f .infrastructure/statefulSet.yml

echo "Waiting for MySQL to be ready..."
kubectl wait --for=condition=ready pod/mysql-0 -n mysql --timeout=120s

echo "Deploying TodoApp..."
kubectl apply -f .infrastructure/clusterIp.yml
kubectl apply -f .infrastructure/nodeport.yml
kubectl apply -f .infrastructure/deployment.yml

sleep 5

echo "Applying HPA..."
kubectl apply -f .infrastructure/hpa.yml

echo "------------------------------------------------"
echo "Deployment finished! Status of all resources:"
kubectl get all -n mysql
kubectl get all -n todoapp