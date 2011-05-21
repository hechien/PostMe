class Post < ActiveRecord::Base
  self.include_root_in_json = false
  has_many :comments
end
