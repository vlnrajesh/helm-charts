{{/*
Expand the name of the chart.
*/}}
{{- define "..name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "..storage-provider-class-name" -}}
{{- printf "%s-secrets-config" .Release.Name | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "..ondemand-deploy" -}}
{{- printf "%s-ondemand" .Release.Name | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- define "..fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Release.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "..chart" -}}
{{- printf "%s-%s" .Release.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "..labels" -}}
helm.sh/chart: {{ include "..chart" . }}
{{ include "..selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
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
{{- define "..topologySpreadConstraints" -}}
topologySpreadConstraints:
  - maxSkew: {{ default 1 .Values.topologySpreadConstraints.maxSkew }}
    topologyKey: {{ default "topology.kubernetes.io/zone" .Values.topologySpreadConstraints.topologyKey }}
    whenUnsatisfiable: {{ default "DoNotSchedule" .Values.topologySpreadConstraints.whenUnsatisfiable }}
    labelSelector:
      matchLabels:
        app.kubernetes.io/name: {{ include "..name" . }}
        app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}