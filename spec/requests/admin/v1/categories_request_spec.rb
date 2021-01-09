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

  context 'POST /categories' do
    context 'with valid params' do
      let(:category_params) { { category: attributes_for(:category) }.to_json }

      before do
        post url, headers: auth_header(user), params: category_params
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(Category.count).to eq(1) }
      it { expect(body_json['category']).to eq(Category.last.as_json(only: %i(id name))) }
    end

    context 'with invalid params' do
      let(:category_invalid_params) { { category: attributes_for(:category, name: nil) }.to_json }

      before do
        post url, headers: auth_header(user), params: category_invalid_params
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(Category.count).to eq(0) }
      it { expect(body_json['errors']['fields']).to have_key('name') }
    end
  end
end
