require 'rails_helper'

describe 'Home', type: :request do
  let(:user) { create(:user) }

  before do
    get '/admin/v1/home', headers: auth_header(user)
  end

  it { expect(response).to have_http_status(:ok) }
  it { expect(body_json).to eq({ 'message' => 'Uhul!' }) }
end