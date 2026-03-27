class BookmarksController < ApplicationController
  require_authentication

  def index
    @bookmarks = current_user.bookmarks.includes(passage: { division: { scripture: :corpus } })
  end

  def create
    passage = Passage.find(params[:passage_id])
    current_user.bookmarks.find_or_create_by!(passage: passage)

    redirect_back fallback_location: root_path
  end

  def destroy
    current_user.bookmarks.find(params[:id]).destroy
    redirect_back fallback_location: bookmarks_path
  end
end
