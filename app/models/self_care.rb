class SelfCare < ApplicationRecord
  validates :reason, presence: true
  validates :am_pm, presence: true
  validate :writeable_date?
  validate :allow_point?

  enum am_pm:{am: 1, pm:2}

  private
  def writeable_date?
    if self.log_date.nil?
      errors.add(:log_date, '日付の選択は必須です')
      return
    end

    if self.log_date > Date.today
      errors.add(:log_date, "未来の日付のは選択できません")
    end
  end

  def allow_point?
    if self.point.nil?
      errors.add(:point, 'ポイントの選択は必須です')
      return
    end

    if self.point < 0
      errors.add(:point, "0から10までしか選択できない")
    end

    if  self.point > 10
      errors.add(:point, "0から10までしか選択できない")
    end

  end

end

