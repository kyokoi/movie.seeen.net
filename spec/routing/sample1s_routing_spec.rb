require "spec_helper"

describe Sample1sController do
  describe "routing" do

    it "routes to #index" do
      get("/sample1s").should route_to("sample1s#index")
    end

    it "routes to #new" do
      get("/sample1s/new").should route_to("sample1s#new")
    end

    it "routes to #show" do
      get("/sample1s/1").should route_to("sample1s#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sample1s/1/edit").should route_to("sample1s#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sample1s").should route_to("sample1s#create")
    end

    it "routes to #update" do
      put("/sample1s/1").should route_to("sample1s#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sample1s/1").should route_to("sample1s#destroy", :id => "1")
    end

  end
end
