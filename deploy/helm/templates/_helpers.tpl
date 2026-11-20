{{/*
Expand the name of the chart.
*/}}
{{- define "..name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "..fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Values.appName .Values.environment | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{- define "..version" -}}
{{- default .Chart.AppVersion .Values.version }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "..chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "..labels" -}}
helm.sh/chart: {{ include "..chart" . }}
{{ include "..selectorLabels" . }}
app.kubernetes.io/version: {{ include "..version" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "..selectorLabels" -}}
app.kubernetes.io/name: {{ include "..name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "..serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "..fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Litestream: the app-storage Secret (see litestream in values.yaml). Named after appName, as
app:storage:add names it, not after the fullname.
*/}}
{{- define "..litestreamSecretName" -}}
{{- .Values.litestream.secretName | default (printf "s3-%s" .Values.appName) -}}
{{- end -}}

{{/*
Litestream: environment for the restore and replicate containers, all from the app-storage
Secret. litestream.yml expands the S3_* variables; Litestream hands the LITESTREAM_* keys to the
S3 client itself, so they never appear in the config.
*/}}
{{- define "..litestreamEnv" -}}
{{- $secret := include "..litestreamSecretName" . -}}
{{- range $name, $key := dict "LITESTREAM_ACCESS_KEY_ID" "accessKeyId" "LITESTREAM_SECRET_ACCESS_KEY" "secretAccessKey" "S3_ENDPOINT" "endpoint" "S3_REGION" "region" "S3_FORCE_PATH_STYLE" "forcePathStyle" "S3_BUCKET" "sqliteBucket" }}
- name: {{ $name }}
  valueFrom:
    secretKeyRef:
      name: {{ $secret }}
      key: {{ $key }}
{{- end }}
{{- end -}}

{{/*
Litestream: what the restore and replicate containers share. They run as the app's user, so the
databases they write stay the app's.
*/}}
{{- define "..litestreamSecurityContext" -}}
allowPrivilegeEscalation: false
capabilities:
  drop:
  - ALL
runAsNonRoot: true
runAsUser: 1000
runAsGroup: 1000
seccompProfile:
  type: RuntimeDefault
{{- end -}}

{{- define "..litestreamMounts" -}}
- name: sqlite
  mountPath: /rails/storage
- name: litestream-config
  mountPath: /etc/litestream
  readOnly: true
{{- end -}}
