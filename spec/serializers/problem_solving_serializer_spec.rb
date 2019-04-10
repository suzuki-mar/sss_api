require 'rails_helper'

describe ProblemSolvingSerializer, :type => :serializer do

  it "必要な要素が定義されていること" do

    model = create(:problem_solving)
    attributes = ProblemSolvingSerializer.new(model).attributes

    expected_keys = [:id, :log_date, :is_draft_text, :problem_recognition, :example_problem, :cause,
                     :phenomenon, :neglect_phenomenon, :progress_status_text, :tags]
    expect(attributes.keys).to match_array(expected_keys)
  end

  describe 'progress_status_text' do

    variables =
      {
          not_started: '未着手',
          doing: '進行中',
          done: '完了',
      }

    variables.each do |key, text|
      it "#{key.to_s}なら#{text}となること" do
        reframing = create(:problem_solving, progress_status: key)
        expect(ProblemSolvingSerializer.new(reframing).progress_status_text).to eq text
      end
    end
  end

end
