class HighlightsController < ApplicationController
  require_authentication

  def create
    @highlight = current_user.highlights.create!(highlight_params)
    head :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    current_user.highlights.find(params[:id]).destroy
    head :no_content
  end

  private

  def highlight_params
    params.require(:highlight).permit(:passage_id, :translation_id, :color, :start_offset, :end_offset, :label)
  end
end
