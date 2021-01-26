module Admin::V1
  class SystemRequirementsController < ApiController
    before_action :load_system_requirement, only: %i[show update destroy]

    def index
      @system_requirements = SystemRequirement.all
    end

    def create
      @system_requirement = SystemRequirement.new(system_requirement_params)
      save_system_requirement!
    end

    def show; end

    def update
      @system_requirement.attributes = system_requirement_params
      save_system_requirement!
    end

    def destroy
      @system_requirement.destroy!
    end

    private

    def system_requirement_params
      return {} unless params.has_key?(:system_requirement)
      params.require(:system_requirement).permit(
        :name, :operational_system, :storage, :processor, :memory, :video_board
      )
    end

    def save_system_requirement!
      @system_requirement.save!
      render :show
    rescue
      render_error(fields: @system_requirement.errors.messages)
    end

    def load_system_requirement
      @system_requirement = SystemRequirement.find(params[:id])
    rescue
      render_error(message: I18n.t('errors.messages.resource_not_found'), status: :not_found)
    end
  end
end