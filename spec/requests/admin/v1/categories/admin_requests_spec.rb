require 'rails_helper'

RSpec.describe "Admin::V1::Categories as :admin", type: :request do
  let(:user) { create(:user, profile: :admin) }
  let(:url) { '/admin/v1/categories' }

  context 'GET /categories' do
    let!(:categories) { create_list(:category, 5) }

    before(:each) do 
      get url, headers: auth_header(user)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(body_json['categories']).to contain_exactly *categories.as_json(only: %i(id name)) }

  end

  context 'GET /categories/:id' do
    context 'with valid id' do
      let(:category) { create(:category) }

      before(:each) do
        get url + "/#{category.id}", headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(body_json['category']).to eq(category.as_json(only: %i[id name]))}
    end

    context 'with invalid id' do
      before(:each) do
        get url + '/9999', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(body_json['errors']).to have_key('message') }
    end

  end

  context 'POST /categories' do
    context 'with valid params' do
      let(:category_params) { { category: attributes_for(:category) }.to_json }

      before(:each) do
        post url, headers: auth_header(user), params: category_params
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(Category.count).to eq(1) }
      it { expect(body_json['category']).to eq(Category.last.as_json(only: %i(id name))) }
    end

    context 'with invalid params' do
      let(:category_invalid_params) { { category: attributes_for(:category, name: nil) }.to_json }

      before(:each) do
        post url, headers: auth_header(user), params: category_invalid_params
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(Category.count).to eq(0) }
      it { expect(body_json['errors']['fields']).to have_key('name') }
    end
  end

  context 'PATCH /categories/:id' do
    let(:category) { create(:category) }
    let(:update_url) { url + "/#{category.id}"}

    context 'with valid params' do
      let(:category_params) { { category: attributes_for(:category) }.to_json }

      before(:each) do
        patch update_url, headers: auth_header(user), params: category_params
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(body_json['category']).to eq(category.reload.as_json(only: %i(id name))) }
    end

    context 'with invalid params' do
      let(:category_invalid_params) { { category: attributes_for(:category, name: nil) }.to_json }

      before(:each) do
        patch update_url, headers: auth_header(user), params: category_invalid_params
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(body_json['errors']['fields']).to have_key('name') }
      it { expect(Category.last).to eq(category) }
    end
  end

  context 'DELETE /categories/:id' do
    let(:category) { create(:category) }
    let(:delete_url) { url + "/#{category.id}" }

    context 'with valid id' do
      before(:each) do
        delete delete_url, headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:no_content) }
      it { expect(Category.exists?(category.id)).to be_falsey }
      it { expect(body_json).to_not be_present }
    end

    context 'with valid id and product_categories' do
      before(:each) do
        create_list(:product_category, 3, category: category)
        create_list(:product_category, 3)
        delete delete_url, headers: auth_header(user)
      end

      it { expect(ProductCategory.where(category_id: category.id).count).to eq(0) }
      it { expect(ProductCategory.count).to eq(3) }
    end

    context 'with invalid id' do
      before(:each) do
        delete url + '/9999', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(body_json['errors']).to have_key('message') }
    end
  end
end
