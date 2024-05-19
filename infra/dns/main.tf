terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.33"
    }
  }
}

resource "cloudflare_record" "yoogle_web_root_dns_record" {
  name    = "@"
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id

  value   = "www.yoogle.com"
  ttl     = 1
  proxied = true
  comment = "Redirect @ to www"
}

resource "cloudflare_record" "yoogle_web_www_dns_record" {
  name    = "www"
  type    = "CNAME"
  zone_id = var.cloudflare_zone_id

  value   = var.website_endpoint
  ttl     = 1
  proxied = true
  comment = "Point www to the S3 bucket"
}
