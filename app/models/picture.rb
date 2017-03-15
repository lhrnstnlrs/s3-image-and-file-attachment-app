class Picture < ApplicationRecord
  belongs_to :imageable, polymorphic: true
  has_attached_file :image, 
  									:styles => { :thumb => "150x150>" }

  validates_attachment :image, 
  		:presence => true,
  		:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] },
			:size => { :in => 0..5.megabytes }
end