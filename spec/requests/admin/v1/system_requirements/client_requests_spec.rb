require 'rails_helper'

RSpec.describe 'Admin::V1::SystemRequirements as :client', type: :request do
  let(:url) { '/admin/v1/system_requirements' }
  let(:user) { create(:user, profile: :client) }

  context 'GET /system_requirements' do
    before(:each) { get url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'POST /system_requirements' do
    before(:each) { post url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'GET /system_requirements/:id' do
    before(:each) { get url + '/9999', headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'PATCH /system_requirements/:id' do
    before(:each) { patch url + '/9999', headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'DELETE /system_requirements/:id' do
    before(:each) { delete url + '/9999', headers: auth_header(user) }
  end
end