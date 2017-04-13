class Picture < ApplicationRecord
  DIRECT_UPLOAD_URL_FORMAT = %r{\Ahttps:\/\/s3upload-sample-db\.s3\.amazonaws\.com\/(?<path>uploads\/.+\/(?<filename>.+))\z}.freeze
  belongs_to :imageable, polymorphic: true, optional: true
  has_attached_file :image, 
  									:styles => { :thumb => "300x100#", :medium => "300x300>" }

  validates_attachment :image,
  		:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },
			:size => { :in => 0..5.megabytes }

  validates :direct_upload_url, presence: true

  before_create :set_upload_attributes
  after_create :queue_finalize_and_cleanup

  def direct_upload_url=(escaped_url)
    write_attribute(:direct_upload_url, (CGI.unescape(escaped_url) rescue nil))
  end

  def update_file(params)
    self.processed = false
    self.attributes = params
    set_upload_attributes
    save!
    Picture.delay.finalize_and_cleanup(id)
  end

  def post_process_required?
    %r{^(image|(x-)?application)/(bmp|gif|jpeg|jpg|pjpeg|png|x-png)$}.match(image_content_type).present?
  end

  def self.finalize_and_cleanup(id)
    picture = Picture.find(id)
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(picture.direct_upload_url)
    
    if picture.post_process_required?
      picture.image = URI.parse(URI.escape(picture.direct_upload_url))
    else
      paperclip_file_path = "pictures/uploads/#{id}/original/#{direct_upload_url_data[:filename]}"
      S3_BUCKET.object(paperclip_file_path).copy_from(direct_upload_url_data[:path])
    end

    picture.processed = true
    picture.save
    
    S3_BUCKET.object(direct_upload_url_data[:path]).delete
  end
      
  protected

  def set_upload_attributes
    tries ||= 5
    direct_upload_url_data = DIRECT_UPLOAD_URL_FORMAT.match(direct_upload_url)
    obj = S3_BUCKET.object(direct_upload_url_data[:path])

    self.image_file_name     = direct_upload_url_data[:filename]
    self.image_file_size     = obj.content_length
    self.image_content_type  = obj.content_type
    self.image_updated_at    = obj.last_modified
  rescue Aws::S3::Errors::NoSuchKey => e
    tries -= 1
    if tries > 0
      sleep(3)
      retry
    else
      false
    end
  end

  def queue_finalize_and_cleanup
    Picture.delay.finalize_and_cleanup(id)
  end
end
