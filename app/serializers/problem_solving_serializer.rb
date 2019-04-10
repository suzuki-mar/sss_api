class ProblemSolvingSerializer < ActiveModel::Serializer

  include Common::DraftSerializer
  include Common::HasTagSerializer

  attributes :id, :log_date, :is_draft_text, :problem_recognition, :example_problem, :cause
  attributes :phenomenon, :neglect_phenomenon, :progress_status_text

  has_many :actions

  def progress_status_text

    values = {
        not_started: '未着手',
        doing: '進行中',
        done: '完了',
    }

    values[object.progress_status.to_sym]
  end


end
