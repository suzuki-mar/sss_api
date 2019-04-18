class SelfCare::Feedback

  include ActiveModel::Model
  include ActiveModel::Serialization

  # TODO クラス内でしか変更できないようにしたい
  attr_reader :is_need_take_care

  ATTENTION_POINT = 7
  BAD_POINT = 6

  def self.load_by_self_care(self_care)
    feedback = self.new
    feedback.send(:set_up_by_self_care, self_care)
    feedback
  end

  private
  # クラス外からは変更できないようにするために
  def set_up_by_self_care(self_care)
    @self_care = self_care
    set_is_need_take_care
  end

  def set_is_need_take_care

    if @self_care.point <= BAD_POINT
      @is_need_take_care = true
      return
    end

    # 不要にSQLを実行させないために先にこちらを実行する
    if @self_care.point > ATTENTION_POINT
      @is_need_take_care = false
      return
    end

    @is_need_take_care = @self_care.prev_logs.all? do |sc|
      sc.point <= ATTENTION_POINT
    end
  end

end