class BuildItemsController < ApplicationController
  PERMIT_ATTRIBUTES = [ :build_id, :item_id ].freeze

  def create
    build_item = BuildItem.new(build_item_params)

    respond_to do |format|
      format.turbo_stream do
        if build_item.save
          @build_item = build_item
          @build = build_item.build
          # Refresh the entire build items table frame
          render turbo_stream: turbo_stream.replace("build_items_table_frame", View::BuildItems::TableFrame.new(build: @build))
        else
          render turbo_stream: turbo_stream.replace("build_items",
            partial: "build_items/form",
            locals: { build_item: build_item })
        end
      end
    end
  end

  def destroy
    build_item = BuildItem.find_by!(id: params[:id])
    @build = build_item.build

    respond_to do |format|
      format.turbo_stream do
        if build_item.destroy
          # Refresh the entire build items table frame after removing an item
          render turbo_stream: turbo_stream.replace("build_items_table_frame", View::BuildItems::TableFrame.new(build: @build))
        else
          render turbo_stream: turbo_stream.replace("build_items_table_frame", View::BuildItems::TableFrame.new(build: @build))
        end
      end

      format.json do
        if build_item.destroy
          render json: { status: :success }, status: :ok
        else
          render json: { status: :error, errors: build_item.errors }, status: :unprocessable_entity
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

  def build_item_params
    params.require(:build_item).permit(PERMIT_ATTRIBUTES)
  end
end
