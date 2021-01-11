require 'rails_helper'

RSpec.describe 'Admin::V1::Categories as :client', type: :request do
  let(:user) { create(:user, profile: :client) }
  let(:url) { '/admin/v1/categories' }

  context 'GET /categories' do
    before(:each) { get url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'POST /categories' do
    before(:each) { post url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'PATCH /categories/:id' do
    before(:each) { patch url + '/1', headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'DELETE /categories/:id' do
    before(:each) { delete url + '/1', headers: auth_header(user) }
    include_examples 'forbidden access'
  end
end