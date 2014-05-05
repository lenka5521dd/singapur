class Area
  include Mongoid::Document
  include Mongoid::Slug
  field :title, type: String
  slug :title
  field :alias, type: String
end
