require 'rails_helper'

RSpec.describe 'Admin::V1::Coupons as :admin', type: :request do
  let(:user) { create(:user, profile: :admin) }
  let(:url) { '/admin/v1/coupons' }

  context 'GET /coupons' do
    let!(:coupons) { create_list(:coupon, 5) }

    before do 
      get url, headers: auth_header(user)
    end

    it { expect(response).to have_http_status(:ok) }
    it { expect(body_json['coupons']).to contain_exactly *coupons.as_json(only: %i[name code status discount_value due_date]) }
  end

  context 'GET /coupons/:id' do
    let(:coupon) { create(:coupon) }

    context 'with valid id' do
      before do
        get url + "/#{coupon.id}", headers: auth_header
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(body_json['coupon']).to eq(coupon.as_json(only: %i[name code status discount_value due_date])) }
    end

    context 'with invalid id' do
      before do
        get url + '/9999', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(body_json['errors']).to have_key('message') }
    end
  end

  context 'POST /coupons' do
    context 'with valid params' do
      let(:coupon_attributes) { { coupon: attributes_for(:coupon) }.to_json }

      before do
        post url, headers: auth_header(user), params: coupon_attributes
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(body_json['coupon']).to eq(Coupon.last.as_json(only: %i[name code status discount_value due_date])) }
      it { expect(Coupon.count).to eq(1) }
    end

    context 'with invalid params' do
      let(:invalid_coupon_attributes) {{ coupon: attributes_for(:coupon, name: nil) }.to_json }

      before do 
        post url, headers: auth_header(user), params: invalid_coupon_attributes
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(Coupon.count).to eq(0) }
      it { expect(body_json['errors'][  'fields']).to have_key('name')}
    end
  end

  context 'PATCH /coupons/:id' do
    let(:coupon) { create(:coupon) }

    context 'with valid params' do
      let(:coupon_attributes) { { coupon: attributes_for(:coupon) }.to_json }

      before do
        patch url + "/#{coupon.id}", headers: auth_header(user), params: coupon_attributes
      end

      it { expect(response).to have_http_status(:ok) }
      it { expect(body_json['coupon']).to eq(coupon.reload.as_json(only: %i[name code status discount_value due_date])) }
    end

    context 'with invalid params' do
      let(:invalid_coupon_attributes) { { coupon: attributes_for(:coupon, status: nil) }.to_json }

      before do
        patch url + "/#{coupon.id}", headers: auth_header(user), params: invalid_coupon_attributes
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(body_json['errors']['fields']).to have_key('status') }
      it { expect(Coupon.last).to eq(coupon) }
    end

    context 'with invalid coupon id' do
      before do
        patch url + '/9999', headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(body_json['errors']).to have_key('message') }
    end
  end

  context 'DELETE /coupons/:id' do
    let(:coupon) { create(:coupon) }

    context 'with valid coupon id' do
      before do
        delete url + "/#{coupon.id}", headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:no_content) }
      it { expect(Coupon.exists?(coupon.id)).to be_falsey }
      it { expect(Coupon.count).to eq(0) }
      it { expect(body_json).to_not be_present}
    end

    context 'with invalid coupon id' do
      before do 
        delete url + "/9999", headers: auth_header(user)
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(body_json['errors']).to have_key('message') }
    end
  end
end