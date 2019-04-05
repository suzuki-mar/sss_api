class SelfCare < ApplicationRecord

  include Swagger::SelfCareSchema
  include ActiveModel::Validations
  include SearchableFromLogDateModel

  belongs_to :self_care_classification

  validates :reason, presence: true
  validates :am_pm, presence: true, uniqueness: { scope: :log_date }
  validates :log_date, log_date_type: true
  validates :point, point_type: true
  validates :am_pm, uniqueness: { scope: :log_date, message: "同じ日付と時期の組み合わせは登録できません" }

  enum am_pm:{am: 1, pm:2}

  def self.create_save_params_of_date(date_time)

    params = {}
    params[:log_date] = Date.new(date_time.year, date_time.month, date_time.day)
    params[:am_pm] = (date_time.hour < 13)? :am : :pm

    params
  end

end

