#!/bin/bash

# Change to the assignment directory
cd ~/assignment3

echo "🚀 Starting Kubernetes deployment for Assignment 3..."

# 1. Apply Namespace
echo "Creating namespace..."
kubectl apply -f k8s/namespace.yml

# 2. Apply Storage
echo "Creating persistent volume and claim..."
kubectl apply -f k8s/mysql-pv.yml
kubectl apply -f k8s/mysql-pvc.yml

# 3. Apply Configuration
echo "Creating configmaps and secrets..."
kubectl apply -f k8s/mysql-secret.yml
kubectl apply -f k8s/flask-configmap.yml
kubectl apply -f k8s/nginx-configmap.yml

# 4. Apply Deployments & Services
echo "Deploying MySQL..."
kubectl apply -f k8s/mysql-deployment.yml
kubectl apply -f k8s/mysql-service.yml

echo "Deploying Flask API..."
kubectl apply -f k8s/flask-deployment.yml
kubectl apply -f k8s/flask-service.yml

echo "Deploying Nginx..."
kubectl apply -f k8s/nginx-deployment.yml
kubectl apply -f k8s/nginx-service.yml

# 5. Wait for Pods to be ready
echo "Waiting for pods to be ready (this may take a minute)..."
kubectl wait --for=condition=ready pod -l app=mysql -n assignment3 --timeout=120s
kubectl wait --for=condition=ready pod -l app=flask -n assignment3 --timeout=120s
kubectl wait --for=condition=ready pod -l app=nginx -n assignment3 --timeout=120s

echo "✅ All services are up and running!"

# 6. Show status
kubectl get all -n assignment3

# 7. Show access URL
echo "Access the application at:"
minikube service nginx-service -n assignment3 --url
