class DraftableSaveService

  attr_reader :error_messages

  def initialize(is_draft_save, target_model, save_params)
    @is_draft_save = is_draft_save
    @target_model = target_model
    @save_params = save_params
    @error_messages = {}
  end

  def execute

    begin
      if @is_draft_save
        @target_model.save_draft!(@save_params)
      else
        @target_model.save_complete!(@save_params)
      end

      true
    rescue => e
      top_key_name = @target_model.class.to_s.underscore.to_sym
      @error_messages[top_key_name] = e.message
      return false
    end

  end
end