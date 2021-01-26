require 'rails_helper'

RSpec.describe 'Admin::V1::Users unauthenticated' do
  let(:url) { '/admin/v1/users' }

  context 'GET /users' do
    before(:each) { get url }
    include_examples 'unauthenticated access'
  end

  context 'POST /users' do
    before(:each) { post url }
    include_examples 'unauthenticated access'
  end

  context 'GET /users/:id' do
    before(:each) { get url + '/9999' }
    include_examples 'unauthenticated access'
  end

  context 'PATCH /users/:id' do
    before(:each) { patch url + '/9999' }
    include_examples 'unauthenticated access'
  end

  context 'DELETE /users/:id' do
    before(:each) { delete url + '/9999'}
    include_examples 'unauthenticated access'
  end
end