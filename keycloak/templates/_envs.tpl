{{- define "envs" }}
{{- $highAvailability := gt (int .Values.replicas) 1 }}
- name: POD_NAME
  valueFrom:
    fieldRef:
      fieldPath: metadata.name
- name: POD_NAMESPACE
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
- name: KEYCLOAK_USER
  value: "admin"
- name: KEYCLOAK_PASSWORD
  value: "{{ pluck .Values.global.env .Values.keycloak.password | first | default .Values.keycloak.password._default }}"
- name: DB_VENDOR
  value: "postgres"
- name: DB_USER
  value: "postgres"
- name: DB_PASSWORD
  value: "{{ .Values.db.password }}"
- name: DB_ADDR
  value: "{{ .Release.Name }}-postgresql-hl"
- name: DB_PORT
  value: "{{ .Values.db.port }}"
- name: DB_DATABASE
  value: "keycloak"
- name: PROXY_ADDRESS_FORWARDING
  value: "true"
- name: JDBC_PARAMS
  value: "sslmode=disable&sslcert=/cockroach-certs/client.keycloak.crt&sslkey=/cockroach-certs/client.keycloak.pk8&sslrootcert=/cockroach-certs/ca.crt"
- name: JDBC_PARAMS_IS
  value: "?sslmode=disable&sslcert=/cockroach-certs/client.keycloak.crt&sslkey=/cockroach-certs/client.keycloak.pk8&sslrootcert=/cockroach-certs/ca.crt"
- name: INFINISPAN_SERVER
  value: "infinispan-server"
- name: JAVA_OPTS
  value: "{{ .Values.java._default }}"
{{- end }}
