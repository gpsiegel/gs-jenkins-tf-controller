output "frontend_repository_url" {
  value = "${aws_ecr_repository.frontend.repository_url}"
}

output "api_repository_url" {
  value = "${aws_ecr_repository.api.repository_url}"
}