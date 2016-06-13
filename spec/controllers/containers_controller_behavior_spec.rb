require 'rails_helper'

describe  ContainersController, type: :controller do

  let(:container) {FactoryGirl.create :container}

  describe 'adds routing' do
    it "routes get index" do
      expect(:get => "/containers/").
          to route_to(:controller => "containers", :action => "index")
    end
    it "routes get show" do
      expect(:get => "/containers/#{container.id}").
          to route_to(:controller => "containers", :action => "show", :id => container.id)
    end
  end

  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "responds successfully with an HTTP 200 status code" do
      get :show, :id => container.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the show template" do
      get :show, :id => container.id
      expect(response).to render_template("show")
    end
  end

end

