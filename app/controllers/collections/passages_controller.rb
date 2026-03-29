module Collections
  class PassagesController < ApplicationController
    require_authentication

    def create
      @collection = current_user.collections.find(params[:collection_id])
      passage = Passage.find(params[:passage_id])
      position = @collection.collection_passages.maximum(:position).to_i + 1
      @collection.collection_passages.find_or_create_by!(passage: passage) do |cp|
        cp.position = position
      end

      redirect_back fallback_location: collection_path(@collection)
    end

    def destroy
      @collection = current_user.collections.find(params[:collection_id])
      @collection.collection_passages.find_by!(passage_id: params[:passage_id]).destroy
      redirect_back fallback_location: collection_path(@collection)
    end
  end
end
