# Splunk Enterprise with SSL enabled on AWS
  
### About
Terraform to deploy Splunk Enterprise on AWS with SSL cert.  You need:
- Terraform 12
- Route53 for the URL
- ACM : Amazon Certificate Manager for the certificate in the Region you want to deploy.
  
### Web UI
Access the Splunk Web UI via the URL from Route53 which is SSL enabled.

### HEC
Access the HEC via SSL enabled URL from Route53.  You can test it with:
  
```bash
curl -k https://your_Route53.com:8088/services/collector -H 'Authorization: Splunk XXXX-Your-HEC-Token-XXXX' -d '{"event": "Hello, world!", "sourcetype": "manual"}'


{"text":"Success","code":0}%  
```