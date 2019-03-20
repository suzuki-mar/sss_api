class SelfCareClassification < ApplicationRecord

  has_many :self_cares, dependent: :destroy

  validates :name, presence: true
  validates :status_group, presence: true

  enum status_group:{good: 1, normal: 2, bad:3}, _prefix: :status

end
