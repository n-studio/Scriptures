module ReadingProgresses
  class TimesController < ApplicationController
    require_authentication

    def create
      rp = current_user.reading_progresses.find_by(passage_id: params[:passage_id])
      if rp
        rp.increment!(:time_spent_seconds, params[:seconds].to_i.clamp(0, 3600))
      end
      head :ok
    end
  end
end
