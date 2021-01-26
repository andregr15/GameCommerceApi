require 'rails_helper'

RSpec.describe 'Admin::V1::Users as :client' do
  let(:url) { '/admin/v1/users' }
  let(:user) { create(:user, profile: :client) }

  context 'GET /users' do
    before(:each) { get url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'POST /users' do
    before(:each) { post url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'GET /users/:id' do
    before(:each) { get url + '/9999', headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'PATCH /users/:id' do
    before(:each) { patch url + '/9999', headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'DELETE /users/:id' do
    before(:each) { delete url + '/9999', headers: auth_header(user) }
    include_examples 'forbidden access'
  end
end