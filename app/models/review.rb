class Review
  include Mongoid::Document
  field :author, type: String
  field :text
end
