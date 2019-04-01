module DraftableModel
  extend ActiveSupport::Concern

  def save_draft!(params)
    params[:is_draft] = true
    self.assign_attributes(params)
    self.save!(context: :draft)
  end

  def save_complete!(params)
    params[:is_draft] = false
    self.assign_attributes(params)
    self.save!(context: :completed)
  end

  def initailize_mode?
    self.is_initailize
  end

  def initialize!
    self.send(:execute_initailize_mode)

    params = {is_draft: true}

    NotImplementedError.new("initialize_paramsを実装してください") unless self.respond_to?(:initialize_params)
    params.merge!(self.initialize_params)
    self.attributes = params
    self.save!
  end

  protected
  attr_accessor :is_initailize

  def execute_initailize_mode
    self.is_initailize = true
  end

  def sef_default_values
    self.is_initailize = false
  end
end
