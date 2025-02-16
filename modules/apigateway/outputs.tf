output "api_id" {
  value = aws_api_gateway_rest_api.weather_api.id
}

output "invoke_url" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}/${aws_api_gateway_resource.weather_resource.path}"
}