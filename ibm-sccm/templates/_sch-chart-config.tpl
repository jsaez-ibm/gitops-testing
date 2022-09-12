{{- /*
Chart specific config file for SCH (Shared Configurable Helpers)
_sch-chart-config.tpl is a config file for the chart to specify additional
values and/or override values defined in the sch/_config.tpl file.

*/ -}}

{{- /*
"sch.chart.config.values" contains the chart specific values used to override or provide
additional configuration values used by the Shared Configurable Helpers.
*/ -}}
{{- define "ibm-sccm.sch.chart.config.values" -}}
sch:
  chart:
    appName: "ibm-sccm"
    metering:
    {{- if eq (toString .Values.licenseType | lower) "non-prod"  }}
      productName: "IBM Control Center Monitor Non-Prod Certified Container"
      productID: "6827a92f0c4447ad8685d9ef4107c949"
    {{- else }}
      productName: "IBM Control Center Monitor Certified Container"
      productID: "3a3896afa0df4d5db217ae67d055e77f"
    {{- end }}
      productVersion: "v6.2"
      productMetric: "VIRTUAL_PROCESSOR_CORE"
      productChargedContainers: "All"
    podSecurityContext:
      runAsNonRoot: true
      supplementalGroups: {{  .Values.storageSecurity.supplementalGroups | default 65534 }} 
      fsGroup: {{  .Values.storageSecurity.fsGroup | default 65534 }}
      runAsUser: {{  .Values.ccArgs.appUserUID | default 1010 }}
      runAsGroup: 0
    initContainerSecurityContext:
      privileged: false
      runAsUser: {{  .Values.ccArgs.appUserUID | default 1010 }}
      readOnlyRootFilesystem: false
      allowPrivilegeEscalation: true
      capabilities:
        drop: [ "ALL" ]
        add: [ "CHOWN", "SETGID", "SETUID", "DAC_OVERRIDE", "FOWNER" ]

    containerSecurityContext:
      privileged: false
      runAsUser: {{  .Values.ccArgs.appUserUID | default 1010 }}
      readOnlyRootFilesystem: false
      allowPrivilegeEscalation: true
      capabilities:
        drop: [ "ALL" ]
        add: [ "CHOWN", "SETGID", "SETUID", "DAC_OVERRIDE", "FOWNER" ]
{{- end -}}

