{{- define "webappImage" }}
- name: webapp
  image: {{ .Values.dockerRepoName | lower }}/k8s-fleetman-helm-demo:v1.0.0{{ if .Values.environment }}-dev{{end}}
{{- end }}