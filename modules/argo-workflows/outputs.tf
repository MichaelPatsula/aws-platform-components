output "s3_bucket" {
    value = aws_s3_bucket.argo_workflows
}

output "sso_service_principal" {
    value = module.argo_workflow_sso_sp
}