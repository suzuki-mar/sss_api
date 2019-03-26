class SelfCare < ApplicationRecord

  include Swagger::SelfCareSchema
  include ActiveModel::Validations

  belongs_to :self_care_classification

  validates :reason, presence: true
  validates :am_pm, presence: true
  validates :log_date, log_date_type: true
  validates :point, point_type: true

  enum am_pm:{am: 1, pm:2}


end

