require 'rails_helper'

RSpec.describe 'Admin::V1::Coupons as :client', type: :request do
  let(:url) { '/admin/v1/coupons' }
  let(:user) { create(:user, profile: :client) }

  context 'GET /coupons' do
    before(:each) { get url, headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'GET /coupons/:id' do
    before(:each) { get url + '/1', headers: auth_header(user) }
    include_examples 'forbidden access'
  end

  context 'PATCH /coupons/:id' do
    before(:each) { patch url + '/1', headers: auth_header(user)}
    include_examples 'forbidden access'
  end

  context 'DELETE /coupons/:id' do
    before(:each) { delete url + '/1', headers: auth_header(user) }
    include_examples 'forbidden access'
  end
end