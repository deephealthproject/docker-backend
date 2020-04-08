{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "deephealth-backend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "deephealth-backend.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "deephealth-backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Return Django admin password
*/}}
{{- define "deephealth-backend.admin.password" -}}
{{- if .Values.backend.admin.password -}}
    {{- .Values.backend.admin.password -}}
{{- else -}}
    {{- randAlphaNum 10 -}}
{{- end -}}
{{- end -}}

{{/*
Return Django static_files url
*/}}
{{- define "deephealth-backend.static_files.url" -}}
/static/
{{- end -}}

{{/*
Return Django static_files path
*/}}
{{- define "deephealth-backend.static_files.path" -}}
{{- $url := .Values.nginx.serverDataVolumePath | trimSuffix "/" -}}
{{- printf "%s/" $url -}}
{{- end -}}

{{/*
Define admin credentials via environment variables.
*/}}
{{- define "deephealth-backend.adminCredentials" -}}
- name: ADMIN_USER
  valueFrom:
    secretKeyRef:
      name: {{ include "deephealth-backend.fullname" . }}-secrets
      key: adminUsername
- name: ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "deephealth-backend.fullname" . }}-secrets
      key: adminPassword
{{- if .Values.backend.admin.email -}}
- name: ADMIN_EMAIL
  valueFrom:
    secretKeyRef:
      name: {{ include "deephealth-backend.fullname" . }}-secrets
      key: adminEmail
{{- end -}}
{{- end -}}

{{/*
Define environment variables in connection between some pods.
*/}}
{{- define "deephealth-backend.common-env" -}}
- name: DJANGO_ENV
  value: "/app/config"
- name: POSTGRES_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "deephealth-backend.fullname" . }}-postgresql
      key: postgresql-password
- name: RABBITMQ_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "deephealth-backend.fullname" . }}-rabbitmq
      key: rabbitmq-password
- name: DATABASE_URL
  value: psql://{{ .Values.postgresql.postgresqlUsername }}:$(POSTGRES_PASSWORD)@{{ include "deephealth-backend.fullname" . }}-postgresql:{{ .Values.postgresql.service.port }}/{{ .Values.postgresql.postgresqlDatabase }}
- name: RABBITMQ_BROKER_URL
  value: amqp://{{ .Values.broker.rabbitmq.username }}:$(RABBITMQ_PASSWORD)@{{ include "deephealth-backend.fullname" . }}-rabbitmq:{{ .Values.broker.service.port }}
{{- end -}}


{{/*
Define mount paths for shared volumes variables in connection between some pods.
*/}}
{{- define "deephealth-backend.common-mount-paths" -}}
- name: backend-secrets
  mountPath: "/app/config"
  subPath: config
- name: datasets-volume
  mountPath: {{ .Values.dataPaths.datasets }}
- name: training-volume
  mountPath: {{ .Values.dataPaths.training }}
- name: inference-volume
  mountPath: {{ .Values.dataPaths.inference }}
{{- end -}}


{{/*
Define shared volumes in connection between some pods.
*/}}
{{- define "deephealth-backend.common-volumes" -}}
- name: backend-secrets
  secret:
    secretName: {{ include "deephealth-backend.fullname" . }}-secrets
    defaultMode: 0644
- name: datasets-volume
  persistentVolumeClaim:
    claimName: {{ include "deephealth-backend.fullname" . }}-datasets
    readOnly: false
- name: training-volume
  persistentVolumeClaim:
    claimName: {{ include "deephealth-backend.fullname" . }}-training
    readOnly: false
- name: inference-volume
  persistentVolumeClaim:
    claimName: {{ include "deephealth-backend.fullname" . }}-inference
    readOnly: false
{{- end -}}