module InitailzeableModel
  extend ActiveSupport::Concern

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
