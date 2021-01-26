require 'rails_helper'

RSpec.describe 'Admin::V1::SystemRequirements unauthenticated' do
  let(:url) { '/admin/v1/system_requirements' }

  context 'GET /system_requirements' do
    before(:each) { get url }
    include_examples 'unauthenticated access'
  end

  context 'POST /system_requirements' do
    before(:each) { post url }
    include_examples 'unauthenticated access'
  end

  context 'GET /system_requirements/:id' do
    before(:each) { get url + '/9999' }
    include_examples 'unauthenticated access'
  end

  context 'PATH /system_requirements/:id' do
    before(:each) { patch url + '/9999' }
    include_examples 'unauthenticated access'
  end

  context 'DELETE /system_requirements/:id' do
    before(:each) { delete url + '/9999' }
    include_examples 'unauthenticated access'
  end
end