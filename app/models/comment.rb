class Comment < ActiveRecord::Base
  self.include_root_in_json = false
  belongs_to :post
end
