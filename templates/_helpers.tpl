{{/*
Expand the name of the chart.
*/}}
{{- define "sovereign-ai-gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sovereign-ai-gateway.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
LiteLLM Defaults Merger
Provides a safe, fully-populated litellm object by deeply merging .Values.litellm onto defaults.
Usage: {{- $litellm := include "sovereign-ai-gateway.litellm" . | fromYaml -}}
*/}}
{{- define "sovereign-ai-gateway.litellm.defaults" -}}
replicaCount: 1
service:
  type: ClusterIP
  port: 4000
serviceMonitor:
  enabled: false
  path: /metrics
networkPolicy:
  enabled: false
pdb:
  create: false
  minAvailable: 1
{{- end -}}

{{- define "sovereign-ai-gateway.litellm" -}}
{{- $defaults := include "sovereign-ai-gateway.litellm.defaults" . | fromYaml -}}
{{- $merged := mergeOverwrite $defaults (default dict .Values.litellm) -}}
{{- $merged | toYaml -}}
{{- end -}}
