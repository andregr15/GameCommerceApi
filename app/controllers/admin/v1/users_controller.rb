module Admin::V1
  class UsersController < ApiController
    before_action :load_user, only: %i[show update destroy]

    def index
      @users = User.all
    end

    def create
      @user = User.new(user_params)
      save_user!
    end

    def show; end

    def update
      @user.attributes = user_params
      save_user!
    end

    def destroy
      @user.destroy
    end

    private

    def user_params
      return {} unless params.has_key?(:user)
      params.require(:user).permit(
        :name, :email, :profile, :password, :password_confirmation
      )
    end

    def load_user
      @user = User.find(params[:id])
    rescue
      render_error(message: I18n.t('errors.message.resource_not_found'), status: :not_found)
    end

    def save_user!
      @user.save!
      render :show
    rescue
      render_error(fields: @user.errors.messages)
    end
  end
end