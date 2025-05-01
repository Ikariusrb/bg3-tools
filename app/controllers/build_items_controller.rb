class BuildItemsController < ApplicationController
  PERMIT_ATTRIBUTES = [ :build_id, :item_id ].freeze

  def create
    binding.pry
    build_item = BuildItem.new(build_item_params)

    respond_to do |format|
      format.turbo_stream do
        binding.pry
        if build_item.save
          render json: { status: :success, build_item: build_item }, status: :created
        else
          render json: { status: :error, errors: build_item.errors }, status: :unprocessable_entity
        end
      end
    end
  end

  def destroy
    build_item = BuildItem.find_by!(id: params[:id])

    if build_item.destroy
      render json: { status: :success }, status: :ok
    else
      render json: { status: :error, errors: build_item.errors }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: :error, message: "Build item not found" }, status: :not_found
  end

  private

  def build_item_params
    params.require(:build_item).permit(PERMIT_ATTRIBUTES)
  end
end
