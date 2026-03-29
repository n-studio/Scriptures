module Curricula
  class PositionsController < ApplicationController
    require_authentication

    def update
      @curriculum = current_user.curricula.find(params[:curriculum_id])
      item_ids = params[:item_ids] || []
      item_ids.each_with_index do |id, index|
        @curriculum.curriculum_items.where(id: id).update_all(position: index + 1)
      end
      head :ok
    end
  end
end
