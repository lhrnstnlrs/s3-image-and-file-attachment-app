class Attachment < ApplicationRecord
  belongs_to :attachable, polymorphic: true, optional: true
  has_attached_file :file

	validates_attachment :file,
  		:presence => true,
  		:content_type => { :content_type => ["application/pdf","application/vnd.ms-excel",     
             "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
             "application/msword", 
             "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
             "text/plain"] },
  		:size => { :in => 0..5.megabytes }

  #do_not_validate_attachment_file_type :file
end
