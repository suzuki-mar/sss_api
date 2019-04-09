class SelfCare < ApplicationRecord

  include Swagger::SelfCareSchema
  include ActiveModel::Validations
  include HasLogDateModel
  include HasTagModel
  include DocumentElementModel

  belongs_to :self_care_classification
  has_many :tag_associations, dependent: :nullify

  validates :reason, presence: true
  validates :am_pm, presence: true, uniqueness: { scope: :log_date }
  validates :log_date, log_date_type: true
  validates :point, point_type: true
  validates :am_pm, uniqueness: { scope: :log_date, message: "同じ日付と時期の組み合わせは登録できません" }

  enum am_pm:{am: 1, pm:2}

  # DocumentElementModel用の実装
  def self.includes_related_items
    with_tags.includes(:self_care_classification)
  end

  # DocumentElementModel用の実装終わり

  def self.create_save_params_of_date(date_time)

    params = {}
    params[:log_date] = Date.new(date_time.year, date_time.month, date_time.day)
    params[:am_pm] = (date_time.hour < 13)? :am : :pm

    params
  end

  def save_with_params(params)
    base_params = params.deep_dup
    base_params.delete('tag_names_text')

    self.assign_attributes(base_params)
    self.save!
    self.save_tags!(params)
  end

  def log_date_time
    hours = am? ? 0 : 13
    Time.zone.local(log_date.year, log_date.month, log_date.day, hours, 0, 0)
  end

end

