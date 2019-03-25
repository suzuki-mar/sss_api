require "rails_helper"

RSpec.describe ReframingsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/reframings").to route_to("reframings#index")
    end

    it "routes to #show" do
      expect(:get => "/reframings/1").to route_to("reframings#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/reframings").to route_to("reframings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/reframings/1").to route_to("reframings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/reframings/1").to route_to("reframings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/reframings/1").to route_to("reframings#destroy", :id => "1")
    end
  end
end
