class SelfCare < ApplicationRecord

  include ActiveModel::Validations
  include HasLogDateModel
  include HasTagModel
  include DocumentElementModel
  include HasActionsModel
  include SearchFromAllTextColumnModel

  belongs_to :self_care_classification
  has_many :tag_associations, dependent: :nullify
  has_many :actions, dependent: :nullify

  validates :reason, presence: true
  validates :am_pm, presence: true, uniqueness: { scope: :log_date }
  validates :log_date, log_date_type: true
  validates :point, point_type: true
  validates :am_pm, uniqueness: { scope: :log_date, message: "同じ日付と時期の組み合わせは登録できません" }

  scope :with_classification, -> { includes(:self_care_classification) }
  scope :order_recent, -> { order('log_date DESC').order('am_pm DESC') }

  enum am_pm:{am: 1, pm:2}

  attr_reader :feedback

  # DocumentElementModel用の実装
  def self.includes_related_items
    includes(self.related_column_keys)
  end

  # DocumentElementModel用の実装終わり

  def self.related_column_keys
    [:self_care_classification, {tag_associations: :tag}]
  end


  def self.create_am_pm_by_date_time(date_time)
    (date_time.hour < 13)? :am : :pm
  end

  def self.create_save_params_of_date(date_time)

    params = {}
    params[:log_date] = Date.new(date_time.year, date_time.month, date_time.day)
    params[:am_pm] = self.create_am_pm_by_date_time(date_time)

    params
  end

  def self.recorded_of_specified_time?(date_time)

    am_pm = self.create_am_pm_by_date_time(date_time)
    SelfCare.where(log_date: date_time).where(am_pm: am_pm).exists?
  end

  def save_with_related_items(params)
    base_params = params.deep_dup
    base_params.delete('tag_names_text')
    base_params.delete('actions')

    self.assign_attributes(base_params)
    self.save!

    self.save_tags!(params)
    self.save_actions!(params)

    self.reload
  end

  def log_date_time
    hours = am? ? 0 : 13
    Time.zone.local(log_date.year, log_date.month, log_date.day, hours, 0, 0)
  end

  def prev_logs
    self_cares = SelfCare.where("log_date <= ?", self.log_date).order_recent

    old_log = self_cares.select do |self_care|
      self.than_newer?(self_care)
    end

    old_log.to(1)
  end

  def than_newer?(compare)
    self.log_date_time > compare.log_date_time
  end

  def set_up_feedback
    feedback = Feedback.load_by_self_care(self)
    @feedback = feedback
  end

end

