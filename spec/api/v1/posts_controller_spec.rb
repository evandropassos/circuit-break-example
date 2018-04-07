require "rails_helper"

describe Api::V1::PostsController, type: :controller do
  context 'GET index' do
    it "when REST response 200" do
        get :index
        json = JSON.parse(response.body)

        expect(json.length).to_not eq(0)
    end
  end
end
