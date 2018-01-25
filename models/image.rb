require './uploader/images_uploader'

class Image < ActiveRecord::Base
  mount_uploader :image, ImagesUploader

  def switch_visibility
    if self.visible == true
      self.visible = false
    elsif self.visible == false
      self.visible = true
    end
    self.save!
  end
end