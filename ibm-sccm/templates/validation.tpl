{{/*
A function to validate if passed parameter is a valid integer
*/}}
{{- define "integerValidation" -}}
{{- $type := kindOf . -}}
{{- if or (eq $type "float64") (eq $type "int") -}}
    {{- $isIntegerPositive := include "isIntegerPositive" . -}}
    {{- if eq $isIntegerPositive "true" -}}
        true
    {{- else -}}
        false
    {{- end -}}
{{- else -}}
    false
{{- end -}}
{{- end -}}

{{/*
A function to validate if passed integer is non negative
*/}}
{{- define "isIntegerPositive" -}}
{{- $inputInt := int64 . -}}
{{- if gt $inputInt -1 -}}
    true
{{- else -}}
    false
{{- end -}}
{{- end -}}

{{/*
A function to validate if passed parameter is a valid string
*/}}
{{- define "stringValidation" -}}
{{- $type := kindOf . -}}
{{- if or (eq $type "string") (eq $type "String") -}}
    true
{{- else -}}
    false
{{- end -}}
{{- end -}}

{{/*
A function to check for mandatory arguments
*/}}
{{- define "mandatoryArgumentsCheck" -}}
{{- if . -}}
    true
{{- else -}}
    false
{{- end -}}
{{- end -}}

{{/*
A function to check for port range
*/}}
{{- define "portRangeValidation" -}}
{{- $portNo := int64 . -}}
{{- if and (gt $portNo 0) (lt $portNo 65536) -}}
    true
{{- else -}}
    false
{{- end -}}
{{- end -}}

{{/*
A function to check if port is valid
*/}}
{{- define "isPortValid" -}}
{{- $result := include "integerValidation" . -}}
{{- if eq $result "true" -}}
        {{- $isPortValid := include "portRangeValidation" . -}}
        {{- if eq $isPortValid "true" -}}
        true
        {{- else -}}
        false
        {{- end -}}
{{- else -}}
        false
{{- end -}}
{{- end -}}


{{/*
A function to check for validity of service ports
*/}}
{{- define "servicePortsCheck" -}}
{{- $result := include "isPortValid" .port -}}
{{- if eq $result "false" -}}
{{- fail "Provide a valid value for ports in service" -}}
{{- end -}}

{{- $result := include "isPortValid" .targetPort -}}
{{- if eq $result "false" -}}
{{- fail "Provide a valid value for targetPort in service" -}}
{{- end -}}

{{- $result := include "isPortValid" .portRange -}}
{{- if eq $result "false" -}}
{{- fail "Provide a valid value for portRange in service" -}}
{{- end -}}
{{- end -}}

{{/*
A function to validate an email address
*/}}
{{- define "emailValidator" -}}
{{- $emailRegex := "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$" -}}
{{- $isValid := regexMatch $emailRegex . -}}
{{- if eq $isValid true -}}
        true
{{- else -}}
        false
{{- end -}}
{{- end -}}

{{/*
A function to validate size
*/}}
{{- define "size" -}}
{{- $sizeRegex := "^[0-9][KMG][i]$" -}}
{{- $isValid := regexMatch $sizeRegex . -}}
{{- if eq $isValid true -}}
        true
{{- else -}}
        false
{{- end -}}
{{- end -}}

{{/*
Main function to test the input validations
*/}}

{{- define "validateInput" -}}

{{- $result := include "mandatoryArgumentsCheck" .Values.image.repository -}}
{{- if eq $result "false" -}}
{{- fail ".Values.image.repository cannot be empty." -}}
{{- end -}}

{{- $result := include "mandatoryArgumentsCheck" .Values.image.tag -}}
{{- if eq $result "false" -}}
{{- fail ".Values.image.tag cannot be empty" -}}
{{- end -}}

{{- $result := include "mandatoryArgumentsCheck" .Values.image.pullPolicy -}}
{{- if eq $result "false" -}}
{{- fail ".Values.pullPolicy cannot be empty" -}}
{{- end -}}

{{- $result := include "mandatoryArgumentsCheck" .Values.secret.secretName -}}
{{- if eq $result "false" -}}
{{- fail "Please provide value for Values.secret.secretName" -}}
{{- end -}}



{{- $result := include "mandatoryArgumentsCheck" .Values.secret.certsSecretName -}}
{{- if eq $result "false" -}}
{{- fail "Please provide value for Values.secret.certsSecretName" -}}
{{- end -}}



{{- $result := include "mandatoryArgumentsCheck" .Values.service.type -}}
{{- if eq $result "false" -}}
{{- fail "Values.service.type cannot be empty" -}}
{{- end -}}

{{- $result := .Values.service.type -}}
{{- if not (or (eq $result "NodePort") (eq $result "LoadBalancer") (eq $result "ClusterIP")) -}}
{{- fail ".Values.service.type is not valid. Valid values are NodePort,LoadBalancer or ClusterIP" -}}
{{- end -}}


{{- $isValid := toString .Values.image.digest.enabled -}}
{{- if eq $isValid "true" -}}
{{- $result := include "mandatoryArgumentsCheck" .Values.image.digest.value -}}
{{- if eq $result "false" -}}
{{- fail "Configuration Missing: .Values.image.digest.value cannot be empty. Please provide a valid image digest value." -}}
{{- end -}}
{{- end -}}


{{- if eq $isValid "false" -}}
{{- $result := include "mandatoryArgumentsCheck" .Values.image.tag -}}
{{- if eq $result "false" -}}
{{- fail "Configuration Missing: .Values.image.tag cannot be empty. Please provide a valid image tag." -}}
{{- end -}}
{{- end -}}



{{- end -}}

{{/*-  include "validateInput" .  -*/}}
