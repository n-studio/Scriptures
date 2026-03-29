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

  private

  def collection_params
    params.require(:collection).permit(:name, :description, :public)
  end
end
