{{/*
Override argo-workflows.namespace to use .Values.namespace, which is the
value automatically injected by the VMware Supervisor service framework.
This file is in templates/supervisor/ so it is loaded after templates/_helpers.tpl
in lexical order, ensuring this definition wins.
*/}}
{{- define "argo-workflows.namespace" -}}
{{- default .Release.Namespace .Values.namespace | trunc 63 | trimSuffix "-" -}}
{{- end -}}
