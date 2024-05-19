
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "github_personal_access_token" {
  description = "GitHub personal access token"
  type        = string
}

