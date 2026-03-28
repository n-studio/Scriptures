class ReadingProgressesController < ApplicationController
  require_authentication

  def create
    passage = Passage.find(params[:passage_id])
    current_user.reading_progresses.find_or_create_by!(passage: passage) do |rp|
      rp.read_at = Time.current
    end
    redirect_back fallback_location: root_path
  end

  def destroy
    current_user.reading_progresses.find_by!(passage_id: params[:passage_id]).destroy
    redirect_back fallback_location: root_path
  end
end
