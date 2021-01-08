require 'rails_helper'

RSpec.describe "Admin::V1::Categories", type: :request do
  let(:user) { create(:user) }
  let(:url) { '/admin/v1/categories' }

  context 'GET /categories' do
    let!(:categories) { create_list(:category, 5) }

    before do 
      get url, headers: auth_header(user)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(body_json['categories']).to contain_exactly *categories.as_json(only: %i(id name)) }

  end
end
