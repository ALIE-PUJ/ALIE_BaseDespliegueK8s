#!/bin/bash

export PASSWORD=$(kubectl get secret --namespace "postgresdb" postgresdb-postgresql-ha-postgresql -o jsonpath="{.data.password}" | base64 -d)

export REPMGR_PASSWORD=$(kubectl get secret --namespace "postgresdb" postgresdb-postgresql-ha-postgresql -o jsonpath="{.data.repmgr-password}" | base64 -d)

export ADMIN_PASSWORD=$(kubectl get secret --namespace "postgresdb" postgresdb-postgresql-ha-pgpool -o jsonpath="{.data.admin-password}" | base64 -d)

echo "PASSWORD=$PASSWORD"
echo "REPMGR_PASSWORD=$REPMGR_PASSWORD"
echo "ADMIN_PASSWORD=$ADMIN_PASSWORD"

