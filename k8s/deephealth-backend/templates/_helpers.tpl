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
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "deephealth-backend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
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