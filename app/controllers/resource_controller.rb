# frozen_string_literal: true

class ResourceController < ApplicationController
  layout -> { ApplicationLayout }

  def index
    if Object.const_defined?("View::#{resource_plural}::Index")
      index_view = "View::#{resource_plural}::Index".constantize
    else
      index_view = View::Resource::Index
    end
    render index_view.new(
      model.all.load_async,
      notice: notice
    )
  end

  def show
    if Object.const_defined?("View::#{resource_plural}::Show")
      show_view = "View::#{resource_plural}::Show".constantize
    else
      show_view = View::Resource::Show
    end
    render show_view.new(
      model.find(id_param),
      notice: notice
    )
  end

  def new
    render edit_view.new(model.new, action: :new, notice: notice)
  end

  def edit
    render edit_view.new(model.find_by!(id: id_param), action: :edit, notice: notice)
  end

  def create
    new_resource = model.new(resource_params)
    new_resource.save!
    success_redirect_dest = public_send("#{resource_singular.downcase}_url", new_resource)
    redirect_to success_redirect_dest, notice: "#{resource_singular} was successfully created"
  rescue ActiveRecord::RecordInvalid => e
    # rerender existing model with errors
    render edit_view.new(new_resource, action: :new)
  end

  def update
    change_resource = model.find_by!(id: id_param)
    change_resource.update!(resource_params)
    success_redirect_dest = public_send("#{resource_singular.downcase}_url", change_resource)
    redirect_to success_redirect_dest, notice: "#{resource_singular} was successfully updated"
  end

  def destroy
    destroy_resource = model.find_by!(id: id_param)
    destroy_resource.destroy!
    redirect_dest = public_send("#{resource_plural.downcase}_url")
    redirect_to redirect_dest, notice: "#{resource_singular} was successfully deleted"
  rescue ActiveRecord::RecordNotDestroyed => e
    redirect_to redirect_dest, notice: "#{resource_singular} could not be deleted: #{e.message}"
  end

  def resource_plural
    @resource_plural ||=
      if defined?(RESOURCE)
        RESOURCE.pluralize.capitalize
      else
        self.class.name.delete_suffix("Controller")
      end
  end

  def resource_singular
    @resource_singular ||= resource_plural.singularize
  end

  def model
    @resource_model ||= resource_singular.constantize
  end

  private

  def edit_view
    @edit_view ||=
      if Object.const_defined?("View::#{resource_plural}::Edit")
        "View::#{resource_plural}::Edit".constantize
      else
        View::Resource::Edit
      end
  end

  def id_param
    @id_param ||= params[:id]
  end

  def resource_params
    @resource_params ||= params
      .require(resource_singular.downcase.to_sym).permit(self.class::PERMIT_ATTRIBUTES)
  end
end
