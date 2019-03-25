require "rails_helper"

RSpec.describe ProblemSolvingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/problem_solvings").to route_to("problem_solvings#index")
    end

    it "routes to #show" do
      expect(:get => "/problem_solvings/1").to route_to("problem_solvings#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/problem_solvings").to route_to("problem_solvings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/problem_solvings/1").to route_to("problem_solvings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/problem_solvings/1").to route_to("problem_solvings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/problem_solvings/1").to route_to("problem_solvings#destroy", :id => "1")
    end
  end
end
