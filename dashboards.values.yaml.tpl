opensearchHosts: "http://opensearch-cluster-master:9200"

ingress:
  enabled: true
  ingressClassName: nginx
  annotations:
    cert-manager.io/issuer: "${LETSENCRYPT_ENVIRONMENT}-opensearch-dashboards"
  hosts:
    - host: opensearch-dashboards.${DNS_DOMAIN}
      paths:
        - path: /
          backend:
            serviceName: opensearch-dashboards
            servicePort: 5601

  tls: 
     - secretName: opensearch-dashboards-tls
       hosts:
         - opensearch-dashboards.${DNS_DOMAIN}
