require 'rails_helper'

RSpec.describe 'Admin::V1::Users as :admin', type: :request do
  let(:url) { '/admin/v1/users' }
  let(:user) { create(:user, profile: :admin) }

  context 'GET /users' do
    let!(:users) { create_list(:user, 5) }

    before(:each) do
      get url, headers: auth_header(user)
    end

    it { expect(response).to have_http_status(:ok) }
    # last user is used to auth_header
    it { expect(body_json['users'][0...5]).to contain_exactly(*users.as_json(only: %i[id name email profile])) }
  end

  context 'POST /users' do
    context 'with valid params' do
      let(:user_attributes) { { user: attributes_for(:user) }.to_json }

      before(:each) do
        post url, headers: auth_header, params: user_attributes
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(User.count).to eq(2) }
      it { expect(body_json['user']).to eq(User.last.as_json(only: %i[id name email profile])) }
    end

    context 'with invalid params' do
      let(:invalid_user_attributes) { { user: attributes_for(:user, name: nil) }.to_json }

      before(:each) do
        post url, headers: auth_header(user), params: invalid_user_attributes
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(body_json['errors']['fields']).to have_key('name') }
    end
  end

  context 'GET /users/:id' do
    context 'with valid id' do
      before(:each) do
        get url + "/#{user.id}", headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(body_json['user']).to eq(user.as_json(only: %i[id name email profile])) }
    end

    context 'with invalid id' do 
      before(:each) do
        get url + '/9999', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(body_json['errors']).to have_key('message') }
    end
  end

  context 'PATCH /users/:id' do
    context 'with valid id' do
      let(:other_user) { create(:user) }

      context 'with valid params' do
        let(:user_attributes) { { user: attributes_for(:user) }.to_json }

        before(:each) do
          patch url + "/#{other_user.id}", headers: auth_header(user), params: user_attributes
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(body_json['user']).to eq(other_user.reload.as_json(only: %i[id name email profile])) }
      end

      context 'with invalid params' do
        let(:invalid_user_attributes) { { user: attributes_for(:user, name: nil) }.to_json }
        
        before(:each) do
          patch url + "/#{other_user.id}", headers: auth_header(user), params: invalid_user_attributes
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(body_json['errors']['fields']).to have_key('name') }
        it { expect(User.first).to eq(other_user) }
      end
    end

    context 'with invalid id' do
      before(:each) do
        patch url + '/9999', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(body_json['errors']).to have_key('message') }
    end
  end

  context 'DELETE /user/:id' do
    context 'with valid id' do
      let(:other_user) { create(:user) }

      before(:each) do
        delete url + "/#{other_user.id}", headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:no_content) }
      it { expect(User.exists?(other_user.id)).to be_falsey }
      it { expect(User.count).to eq(1) }
      it { expect(body_json).not_to be_present }
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