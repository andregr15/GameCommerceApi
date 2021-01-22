require 'rails_helper'

RSpec.describe 'Admin::V1::Categories without authentication', type: :request do
  let(:url) { '/admin/v1/coupons' }

  context 'GET /coupons' do
    before(:each) { get url }
    include_examples 'unauthenticated access'
  end

  context 'GET /coupons/:id' do
    before(:each) { get url + '/1' }
    include_examples 'unauthenticated access'
  end

  context 'POST /coupons' do
    before(:each) { post url }
    include_examples 'unauthenticated access'
  end

  context 'PATCH /coupons/:id' do
    before(:each) { patch url + '/1' }
    include_examples 'unauthenticated access'
  end

  context 'DELETE /coupons/:id' do
    before(:each) { delete url + '/1' }
    include_examples 'unauthenticated access'
  end
end