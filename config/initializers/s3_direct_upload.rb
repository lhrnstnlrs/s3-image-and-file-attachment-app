S3DirectUpload.config do |c|
  c.access_key_id     = ENV.fetch('AWS_ACCESS_KEY_ID')
  c.secret_access_key = ENV.fetch('AWS_SECRET_ACCESS_KEY')
  c.bucket            = ENV.fetch('AWS_S3_BUCKET_NAME')
  c.region            = ENV.fetch('AWS_REGION')
  c.url               = "https://s3upload-sample-db.s3.amazonaws.com/"
end