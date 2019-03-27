class User < ApplicationRecord

  has_many :meetings
  has_many :events, through: :meetings
end
