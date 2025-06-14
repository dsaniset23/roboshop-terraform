provider "vault" {
  address         = "http://vault-internal.devops24.shop:8200"
  token           = var.vault_token
  skip_tls_verify = true
}