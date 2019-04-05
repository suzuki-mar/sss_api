class SelfCareClassification < ApplicationRecord

  has_many :self_cares, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :status_group, message: "同じ分類で同じ名前は登録できません"  }
  validates :status_group, presence: true

  enum status_group:{good: 1, normal: 2, bad:3}, _prefix: :status

  scope :for_selecting, -> { order(:status_group) }

end
