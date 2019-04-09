class SelfCareClassification < ApplicationRecord

  has_many :self_cares, dependent: :nullify

  validates :name, presence: true, uniqueness: { scope: :status_group, message: "同じ分類で同じ名前は登録できません"  }
  validates :status_group, presence: true

  enum status_group:{good: 1, normal: 2, bad:3}, _prefix: :status

  scope :for_selecting, -> { order(:status_group) }


  def self.convert_for_grouped_by_status_group(target)
    self_cares_grouped_by_status_group = {}
    self.status_groups.keys.each do |key|
      self_cares_grouped_by_status_group[key] = []
    end

    target.each do |sc|
      status_group = sc.self_care_classification.status_group
      self_cares_grouped_by_status_group[status_group] << sc
    end

    self_cares_grouped_by_status_group
  end
end
