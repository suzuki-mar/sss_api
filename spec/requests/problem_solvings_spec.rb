require 'rails_helper'

RSpec.describe "ProblemSolvings", type: :request do
  describe "GET /problem_solvings" do
    it "works! (now write some real specs)" do
      get problem_solvings_path
      expect(response).to have_http_status(200)
    end
  end
end
