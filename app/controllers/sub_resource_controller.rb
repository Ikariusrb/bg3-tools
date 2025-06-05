# frozen_string_literal: true

class SubResourceController < ApplicationController
  include ResourceNaming

  def create
    new_resource = model.new(resource_params)
    parent_resource = new_resource.public_send(self.class::PARENT_RESOURCE)

    respond_to do |format|
      format.turbo_stream do
        if new_resource.save
          # Refresh the entire build items table frame
          render turbo_stream: turbo_stream.replace(sub_frame_name, View::BuildItems::SubFrame.new(build: parent_resource))
        else
          render turbo_stream: turbo_stream.replace("resource_form",
            View::Builds::EditForm.new(parent_resource, action: :edit),
            locals: { build_item: new_resource })
        end
      end
    end
  end

  def destroy
    resource = model.find_by!(id: params[:id])
    parent_resource = resource.public_send(self.class::PARENT_RESOURCE)

    respond_to do |format|
      format.turbo_stream do
        if resource.destroy
          # Refresh the entire build items table frame after removing an item
          render turbo_stream: turbo_stream.replace(sub_frame_name, View::BuildItems::SubFrame.new(build: parent_resource))
        else
          render turbo_stream: turbo_stream.replace(sub_frame_name, View::BuildItems::SubFrame.new(build: parent_resource))
        end
      end

      format.json do
        if resource.destroy
          render json: { status: :success }, status: :ok
        else
          render json: { status: :error, errors: resource.errors }, status: :unprocessable_entity
        end
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("flash", partial: "shared/flash", locals: { message: "Build item not found", type: "error" })
      end
      format.json do
        render json: { status: :error, message: "Build item not found" }, status: :not_found
      end
    end
  end

  private

  def sub_frame_name
    @sub_frame_name ||= "#{resource_plural.underscore}_sub_frame"
  end

  def sub_resource_frame_view
    @sub_resource_frame_view ||=
      if Object.const_defined?("View::#{resource_plural}::SubFrame")
        "View::#{resource_plural}::SubFrame".constantize
      else
        View::Resource::SubFrame
      end
  end

  def parent_resource_edit_view
    @parent_resource_edit_view ||=
      if Object.const_defined?("View::#{parent_resource_plural}::EditForm")
        "View::#{parent_resource_plural}::EditForm".constantize
      else
        View::Resource::Edit
      end
  end

  def resource_params
    @resource_params ||= params
      .require(resource_singular.underscore.to_sym).permit(self.class::PERMIT_ATTRIBUTES)
  end
end
