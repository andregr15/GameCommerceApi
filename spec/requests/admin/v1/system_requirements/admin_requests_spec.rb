require 'rails_helper'

RSpec.describe 'Admin::V1::SystemRequirements as :admin', type: :request do
  let(:user) { create(:user, profile: :admin) }
  let(:url) { '/admin/v1/system_requirements' }

  context 'GET /system_requirements' do
    let!(:system_requirements) { create_list(:system_requirement, 5) }

    before(:each) do
      get url, headers: auth_header(user)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(body_json['system_requirements']).to contain_exactly(*system_requirements.as_json(only: %i[id name operational_system storage processor memory video_board])) }
  end

  context 'GET /system_requirements/:id' do
    context 'with valid id' do
      let(:system_requirement) { create(:system_requirement) }

      before(:each) do
        get url + "/#{system_requirement.id}", headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(body_json['system_requirement']).to eq(system_requirement.as_json(only: %i[id name operational_system storage processor memory video_board])) }
    end

    context 'with invalid id' do
      before(:each) do
        get url + '/9999', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(body_json['errors']).to have_key('message') }
    end
  end

  context 'POST /system_requirements' do
    context 'with valid params' do
      let(:system_requirement_attributes) { { system_requirement: attributes_for(:system_requirement) }.to_json }

      before(:each) do
        post url, params: system_requirement_attributes, headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(SystemRequirement.count).to eq(1) }
      it { expect(body_json['system_requirement']).to eq(SystemRequirement.first.as_json(only: %i[id name operational_system storage processor memory video_board])) }
    end

    context 'with invalid params' do
      let(:invalid_system_requirement_attributes) { { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json }

      before(:each) do
        post url, params: invalid_system_requirement_attributes, headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(SystemRequirement.count).to eq(0) }
      it { expect(body_json['errors']['fields']).to have_key('name') }
    end
  end

  context 'PATCH /system_requirements/:id' do
    context 'with valid id' do
      let(:system_requirement) { create(:system_requirement) }

      context 'with valid params' do  
        let(:system_requirement_attributes) { { system_requirement: attributes_for(:system_requirement) }.to_json }

        before(:each) do
          patch url + "/#{system_requirement.id}", params: system_requirement_attributes, headers: auth_header(user)
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect(body_json['system_requirement']).to eq(SystemRequirement.first.as_json(only: %i[id name operational_system storage processor memory video_board])) }
      end

      context 'with invalid params' do
        let(:invalid_system_requirement_attributes) { { system_requirement: attributes_for(:system_requirement, name: nil) }.to_json }

        before(:each) do
          patch url + "/#{system_requirement.id}", params: invalid_system_requirement_attributes, headers: auth_header(user)
        end

        it { expect(response).to have_http_status(:unprocessable_entity) }
        it { expect(SystemRequirement.last).to eq(system_requirement) }
        it { expect(body_json['errors']['fields']).to have_key('name') }
      end
    end

    context 'with invalid id' do
      before(:each) do
        patch url + "/9999", headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(body_json['errors']).to have_key('message') }
    end
  end

  context 'DELETE /system_requirements/:id' do
    context 'with valid id' do
      let(:system_requirement) { create(:system_requirement) }

      before(:each) do
        delete url + "/#{system_requirement.id}", headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:no_content) }
      it { expect(SystemRequirement.count).to eq(0) }
      it { expect(SystemRequirement.exists?(system_requirement.id)).to be_falsey }
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