require 'aws-sdk'

aws_config = Rails.application.config_for(:s3)

Aws.config.update(
  # by default the AWS logs go to STDOUT, this helps it play well with Avvo App Works and syslog
  logger: Rails.logger,
  credentials: Aws::Credentials.new(aws_config['access_key_id'], aws_config['secret_access_key']),
  region: aws_config['region'],
)
