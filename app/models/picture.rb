class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_attached_file :image, 
  									:styles => { :thumb => "300x100#", :medium => "300x300>" }

  validates_attachment :image, 
  		:presence => true,
  		:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },
			:size => { :in => 0..5.megabytes }

	before_image_post_process :allow_only_images
  def allow_only_images
    if !(image.content_type =~ %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$})
      return false 
    end
  end 
end