#################
### Providers ###
#################

provider "aws" {
  region = "ca-central-1"
}

##############
### Module ###
##############

module "argocd_secrets" {
  source = "../"

  name = "example"

  argo_workflow_secrets = {
    sso_service_principal = {
      client_id     = "test"
      client_secret = "test"
    }
    artifact_repository = {
      bucket = "test"
      region = "test"
    }
  }

  argocd_secrets = {
    helm_repositories = {
      test = {
        url      = "test"
        username = "test"
        password = "test"
      }
    }
    git_repositories = {
      test = {
        url      = "test"
        username = "test"
        password = "test"
      }
    }
    cluster_registration = {
      cluster_server_fqdn = "test"
      sa_bearer_token     = "test"
      sa_cacert           = "test"
    }
  }

  kubernetes_cluster = {
    load_balancer_subnet_name = "test"
  }

  cnp_controller = {
    image_pull_secret = "test"
  }

  kiali_secrets = {
    grafana_token = "test"
  }

  kubecost_secrets = {
    service_principal = {
      client_id     = "test"
      client_secret = "test"
    }
  }

  loki_secrets = {
    username = "test"
    password = "test"
  }

  velero_secrets = {
    s3 = {
      bucket = "test"
    }
  }

  grafana_secrets = {
    sso_service_principal = {
      client_id     = "test"
      client_secret = "test"
    }
  }

  alertmanager_secrets = {
    msteams_connector = {
      testing           = "test"
      prod_critical     = "test"
      prod_major        = "test"
      prod_minor        = "test"
      non_prod_critical = "test"
      non_prod_major    = "test"
      non_prod_minor    = "test"
      dev_critical      = "test"
      dev_major         = "test"
      dev_minor         = "test"
    }
    smtp = {
      smarthost = "test"
      username  = "test"
      password  = "test"
    }
  }
}
