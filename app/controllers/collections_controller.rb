class CollectionsController < ApplicationController
  require_authentication except: :show

  def index
    @collections = current_user.collections.includes(:passages)
  end

  def show
    @collection = Collection.find(params[:id])

    unless @collection.public? || (authenticated? && @collection.user == current_user)
      redirect_to root_path, alert: "Collection not found."
    end

    @collection_passages = @collection.collection_passages.includes(passage: { division: { scripture: :corpus } })
  end

  def create
    @collection = current_user.collections.create!(collection_params)
    redirect_to collection_path(@collection), notice: "Collection created."
  end

  def update
    @collection = current_user.collections.find(params[:id])
    @collection.update!(collection_params)
    redirect_to collection_path(@collection), notice: "Collection updated."
  end

  def destroy
    current_user.collections.find(params[:id]).destroy
    redirect_to collections_path
  end

  def add_passage
    @collection = current_user.collections.find(params[:id])
    passage = Passage.find(params[:passage_id])
    position = @collection.collection_passages.maximum(:position).to_i + 1
    @collection.collection_passages.find_or_create_by!(passage: passage) do |cp|
      cp.position = position
    end

    redirect_back fallback_location: collection_path(@collection)
  end

  def remove_passage
    @collection = current_user.collections.find(params[:id])
    @collection.collection_passages.find_by!(passage_id: params[:passage_id]).destroy
    redirect_back fallback_location: collection_path(@collection)
  end

  private

  def collection_params
    params.require(:collection).permit(:name, :description, :public)
  end
end
