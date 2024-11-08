# Configuración de Despliegue del Cluster ALIE - ALIE_BaseDespliegueK8s

Módulo de ALIE que contiene las configuraciones necesarias para desplegar el proyecto en un clúster de Kubernetes, asegurando escalabilidad y disponibilidad.

## CockroachDB

**DNS del Servicio:** cockroach-public.default.svc.cluster.local
**Puertos:** 
  - 26258/TCP8080
  - 8080/TCP8080
  - 26257/TCP
**Usuario:** aliedb
**Contraseña:** laiDu9ah

## MilvusDB

**DNS del Servicio:** milvusdb.milvusdb.svc.cluster.local
**Puertos:** 
  - 19530/TCP
  - 9091/TCP

## MongoDB

**DNS del Servicio:** prod-mongodb-svc.mongodb.svc.cluster.local
**Puertos:** 
  - 27017/TCP
**Usuario:** user
**Contraseña:** <secreto de k8s>

