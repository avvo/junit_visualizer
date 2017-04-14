class Suite < ApplicationRecord

  DEFAULT_NAME = 'default'

  belongs_to :project
  has_many :testcases, dependent: :destroy

  has_many :builds, through: :project

  validates_presence_of :name

end
