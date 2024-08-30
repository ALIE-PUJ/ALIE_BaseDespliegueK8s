#!/bin/bash

export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgresdb postgresdb-postgresql-ha-postgresql -o jsonpath="{.data.password}" | base64 -d)
export REPMGR_PASSWORD=$(kubectl get secret --namespace postgresdb postgresdb-postgresql-ha-postgresql -o jsonpath="{.data.repmgr-password}" | base64 -d)

kubectl delete pod postgresdb-postgresql-ha-client -n postgresdb
kubectl run postgresdb-postgresql-ha-client --rm --tty -i --restart='Never' --namespace postgresdb --image docker.io/bitnami/postgresql-repmgr:16.4.0-debian-12-r5 --env="PGPASSWORD=$POSTGRES_PASSWORD"  \
        --command -- psql -h postgresdb-postgresql-ha-pgpool -p 5432 -U postgres -d alie_db
