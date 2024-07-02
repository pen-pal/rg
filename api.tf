resource "aws_apigatewayv2_api" "rag_api" {
  name          = "rag_api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "rag_integration" {
  api_id           = aws_apigatewayv2_api.rag_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.rag_function.invoke_arn
}

resource "aws_apigatewayv2_route" "rag_route" {
  api_id    = aws_apigatewayv2_api.rag_api.id
  route_key = "GET /rag"
  target    = "integrations/${aws_apigatewayv2_integration.rag_integration.id}"
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rag_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.rag_api.execution_arn}/*/*"
}
