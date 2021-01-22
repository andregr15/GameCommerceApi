module Admin::V1
  class CouponsController < ApiController
    before_action :load_coupon, only: %i[show update destroy]
    
    def index
      @coupons = Coupon.all
    end

    def show; end

    def create
      @coupon = Coupon.new(coupon_params)
      save_coupon!
    end

    def update
      @coupon.attributes = coupon_params
      save_coupon!
    end

    def destroy
      @coupon.destroy!
    end

    private

    def coupon_params
      return {} unless params.has_key?(:coupon)
      params.require(:coupon).permit(:name, :code, :status, :discount_value, :due_date)
    end

    def save_coupon!
      @coupon.save!
      render :show
    rescue
      render_error(fields: @coupon.errors.messages)
    end

    def load_coupon
      @coupon = Coupon.find(params[:id])
    rescue
      render_error(message: I18n.t('error.messages.resource_not_found'), status: :not_found)
    end
  end
end