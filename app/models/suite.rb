class Suite < ApplicationRecord
  belongs_to :project
  has_many :testcases, dependent: :destroy

  has_many :builds, through: :project
end
