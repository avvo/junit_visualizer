class Suite < ApplicationRecord

  DEFAULT_NAME = 'default'

  belongs_to :project
  has_many :testcases, dependent: :destroy

  has_many :builds, through: :project

end
