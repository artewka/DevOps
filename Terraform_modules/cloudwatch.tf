resource "aws_cloudwatch_dashboard" "terraform" {
  dashboard_name = "Dashboard_from_Terraform"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 12,
      "properties": {
        "metrics": [
        [ 
          "AWS/ApplicationELB", 
          "RequestCount", 
          "AvailabilityZone", 
          "eu-central-1a" 
        ]
      ],
      "region": "eu-central-1",
      "title": "RequestCountfromELB"
      }
    },
    {
      "type": "text",
      "x": 0,
      "y": 7,
      "width": 3,
      "height": 3,
      "properties": {
        "markdown": "Test"
      }
    }
  ]
}
EOF
}


resource "aws_cloudwatch_metric_alarm" "alarm" {
  alarm_name                = "terraform-test"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  threshold                 = "10"
  alarm_description         = "Request error rate has exceeded 10%"
  insufficient_data_actions = []

  metric_query {
    id          = "e1"
    expression  = "m2/m1*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = "alb"
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "HTTPCode_ELB_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = "120"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        LoadBalancer = "alb"
      }
    }
  }
}
