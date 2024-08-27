#!/bin/bash

kubectl delete pod postgresdb-postgresql-ha-client -n postgresdb
kubectl run postgresdb-postgresql-ha-client --rm --tty -i --restart='Never' --namespace postgresdb --image docker.io/bitnami/postgresql-repmgr:16.4.0-debian-12-r5 --env="PGPASSWORD=$POSTGRES_PASSWORD"  \
        --command -- psql -h postgresdb-postgresql-ha-pgpool -p 5432 -U postgres -d alie_db
