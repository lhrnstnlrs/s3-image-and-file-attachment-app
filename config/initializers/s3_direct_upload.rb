S3DirectUpload.config do |c|
  c.access_key_id     = ENV['AWS_ACCESS_KEY_ID']
  c.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
  c.bucket            = ENV['AWS_S3_BUCKET_NAME']
  c.region            = "ap-southeast-1"
  c.url               = "https://s3upload-sample-db.s3.amazonaws.com/"
end
