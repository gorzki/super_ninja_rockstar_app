class ApplicationRecord < ActiveRecord::Base
  include PluckToStruct

  self.abstract_class = true
end
