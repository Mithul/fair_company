class Company < ApplicationRecord
  belongs_to :admin, class_name: 'User'
  has_many :ratings
end
