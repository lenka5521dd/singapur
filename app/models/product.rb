class Product
  include Mongoid::Document
  field :title, type: String
  field :desc, type: String
  field :price, type: String
  field :weight, type: String
  field :avail, type: String
  field :image_title, type: String
  mount_uploader :image, ImageUploader
end
