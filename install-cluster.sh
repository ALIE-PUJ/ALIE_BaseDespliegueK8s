#!/bin/bash

# Add Helm Repos
helm repo add mongodb https://mongodb.github.io/helm-charts
helm repo add milvus https://zilliztech.github.io/milvus-helm/
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo add jenkinsci https://charts.jenkins.io

# Update Repos
helm repo update

# Install MongoDB
helm upgrade --install community-operator mongodb/community-operator -n mongodb --create-namespace
kubectl apply -f mongodbcommunity_cr.yaml -n mongodb

# Install PostgreSQL
helm upgrade --install postgresdb oci://registry-1.docker.io/bitnamicharts/postgresql-ha -n postgresdb --create-namespace

# Install MilvusDB
helm upgrade --install milvusdb milvus/milvus -n milvusdb -f milvus_values.yml --create-namespace

# Install Kubernetes Dashboard
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
kubectl apply -f k8s-dashboard/

# Install Jenkins
helm upgrade --install jenkins jenkinsci/jenkins -f jenkins/jenkins-values.yaml -n jenkins --create-namespace
kubectl apply -f jenkins/jenkins-dind-storage.yaml -n jenkins

# Install
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f argocd-ingress.yaml -n argocd
