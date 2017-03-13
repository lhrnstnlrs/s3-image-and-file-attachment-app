class Post < ApplicationRecord
	has_many :attachments, as: :attachable, dependent: :destroy
  has_many :pictures, as: :imageable, dependent: :destroy
	validates :title, presence: true
	#accepts_nested_attributes_for :pictures, :allow_destroy: true
end
