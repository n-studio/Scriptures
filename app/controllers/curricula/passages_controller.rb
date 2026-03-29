module Curricula
  class PassagesController < ApplicationController
    require_authentication

    def create
      @curriculum = current_user.curricula.find(params[:curriculum_id])
      passage = Passage.find(params[:passage_id])
      position = @curriculum.curriculum_items.maximum(:position).to_i + 1
      @curriculum.curriculum_items.find_or_create_by!(passage: passage) do |ci|
        ci.position = position
        ci.title = params[:title]
        ci.notes = params[:notes]
      end

      redirect_back fallback_location: curriculum_path(@curriculum)
    end

    def destroy
      @curriculum = current_user.curricula.find(params[:curriculum_id])
      @curriculum.curriculum_items.find_by!(passage_id: params[:passage_id]).destroy
      redirect_back fallback_location: curriculum_path(@curriculum)
    end
  end
end
