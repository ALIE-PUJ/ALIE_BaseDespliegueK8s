#!/bin/bash

# Get administrator access
echo "Super-user required!"
sudo echo "Successfully granted!" || echo "Failed sudo authentication"

# Add Helm Repos
helm repo add mongodb https://mongodb.github.io/helm-charts
helm repo add milvus https://zilliztech.github.io/milvus-helm/
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo add jenkinsci https://charts.jenkins.io
helm repo add harbor https://helm.goharbor.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

# Update Repos
helm repo update

# Install MongoDB
helm upgrade --install community-operator mongodb/community-operator -n mongodb --create-namespace
kubectl apply -f mongodbcommunity_cr.yaml -n mongodb

# Install PostgreSQL
helm upgrade --install postgresdb oci://registry-1.docker.io/bitnamicharts/postgresql-ha -n postgresdb --create-namespace \
        -f postgresdb-values.yaml

# Install MilvusDB
helm upgrade --install milvusdb milvus/milvus -n milvusdb -f milvus_values.yml --create-namespace

# Install Kubernetes Dashboard
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
kubectl apply -f k8s-dashboard/

# Install Jenkins
helm upgrade --install jenkins jenkinsci/jenkins -f jenkins/jenkins-values.yaml -n jenkins --create-namespace
kubectl apply -f jenkins/jenkins-dind-storage.yaml -n jenkins
kubectl apply -n jenkins -f jenkins/jenkins-ingress.yaml

# Install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f argocd/argocd-config.yaml -n argocd
kubectl apply -f argocd/argocd-ingress.yaml -n argocd

# Install Harbor Registry
helm upgrade --install harbor harbor/harbor -f harbor-values.yaml -n harbor --create-namespace

# Configure Traefik
sudo cp -fv traefik/traefik-config.yaml /var/lib/rancher/k3s/server/manifests/

# Restart K3s
echo Restarting K3s ...
sudo systemctl restart k3s
echo Restarted!

# Install Prometheus
helm install monitoring -n monitoring --create-namespace prometheus-community/prometheus

# Install Grafana
helm install grafana grafana/grafana -n monitoring

helm repo add emberstack https://emberstack.github.io/helm-charts
helm repo update
helm upgrade --install reflector emberstack/reflector -n reflector --create-namespace
