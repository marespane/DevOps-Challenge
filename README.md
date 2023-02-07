# Sources 

* CockroachDB Helm Chart: https://github.com/cockroachdb/helm-charts/tree/master/cockroachdb
* Postgress Helm chart from here: https://bitnami.com/stack/postgresql/helm
* Used this blogpost https://blog.palark.com/ha-keycloak-infinispan-kubernetes/ and their repo https://github.com/flant/examples/tree/master/2021/07-keycloak

# Deploying Keycloak with Infinispan in Kubernetes

First we need to add jars as config maps, they are too big to be added as files, and I didn't want to create new images

```
# Create configmaps from necessary jars
kubectl create configmap postgresql-jar --from-file jar/postgresql-42.2.19.jar
kubectl create configmap keycloak-metrics-spi-jar --from-file jar/keycloak-metrics-spi-2.2.0.jar
k create configmap keycloak-model-jpa-jar --from-file jar/keycloak-model-jpa-12.0.4.jar

# Install helm chart
helm install keycloak keycloak

# Create keycloak database in postgresql 
kubectl exec keycloak-postgresql-0 -- bash -c 'export PGPASSWORD=SKEm7XKaDV; psql --username=postgres  --command="CREATE DATABASE keycloak"'

# Delete failing keycloak pod, stuck in some strange CrashLoopBackOff loop
k delete po keycloak-0
```


# Issues that i encountered
* Certificates issue with Cockroachdb 
* Cockroachdb doesn't work with Infinispan due to "unauthorized to access tenant"
  * Tried different versions of Cockroachdb and drivers
  * Moved to Postgressql, left Cockroachdb for certificate generation
* PostgresSQL helm chart doesn't create automatically database, I added init sql script like in https://stackoverflow.com/questions/55499984/postgresql-in-helm-initdbscripts-parameter but container crashes in that init stage.
* It seems that Keycloak is failing for some reason, I didn't found reason. I added DEBUG log configuration but still there are no obvious errors. I'm guessing process is killed by OOM killer.

# Improvements
* Remove hardcoded values from helm charts
* Add init containers which check if all services required by current pod are healthy. This is much cleaner than to wait for container to restart until all reqrements are met
* Better organize helm charts under one umbrella chart so configuration important for us is visible in one values.yaml file

# Conclusion

I tried to configure scalable solution which seemed to be finished, with almost all 'Nice to have' requirements except authentication for the remote Infinispan caches.
But solution I tried to apply is lacking and doesn't work with this limited effort. In real environment I would try few more days, depending on deadline, to fix it up. If not, I would based on this existing solution and newer Keycloak helm chart located in https://www.keycloak.org/getting-started/getting-started-kube implemented combined solution.

