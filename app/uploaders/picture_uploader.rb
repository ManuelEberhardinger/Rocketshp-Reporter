# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  process :convert => 'png'
  process :tags => ['post_picture']

  version :standard do
    eager
    process :resize_to_fill => [100, 150, :north]
  end

  version :thumbnail do
    eager
    cloudinary_transformation radius: 20, width: 100, height: 100, crop: :thumb, gravity: :face
  end

  def public_id
    return model.name.split.join
  end
end
