module Common
  module DraftSerializer

    def is_draft_text
      object.is_draft ? '下書き' : '記入済み'
    end


  end
end