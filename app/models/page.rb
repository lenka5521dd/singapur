class Page
  include Mongoid::Document
  include Mongoid::Slug
  field :title, type: String
  slug :title



end
