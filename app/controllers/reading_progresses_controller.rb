class ReadingProgressesController < ApplicationController
  require_authentication

  def create
    passage = Passage.find(params[:passage_id])
    current_user.reading_progresses.find_or_create_by!(passage: passage) do |rp|
      rp.read_at = Time.current
    end
    redirect_back fallback_location: root_path
  end

  def time
    rp = current_user.reading_progresses.find_by(passage_id: params[:passage_id])
    if rp
      rp.increment!(:time_spent_seconds, params[:seconds].to_i.clamp(0, 3600))
    end
    head :ok
  end

  def destroy
    current_user.reading_progresses.find_by!(passage_id: params[:passage_id]).destroy
    redirect_back fallback_location: root_path
  end
end
