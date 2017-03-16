class Suite < ApplicationRecord
  belongs_to :project
  has_many :testcases, dependent: :destroy
end
