require './uploader/images_uploader'

class Image < ActiveRecord::Base
  mount_uploader :image, ImagesUploader
end