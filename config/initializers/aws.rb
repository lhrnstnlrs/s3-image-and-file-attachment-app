require 'aws-sdk'

Aws.config.update({
  logger: Rails.logger,
  region: 'ap-southeast-1',
  credentials: Aws::Credentials.new( ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'] )
})

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['AWS_S3_BUCKET_NAME'])
