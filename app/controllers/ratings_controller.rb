class RatingsController < ApplicationController
  require_authentication

  def create
    rating = current_user.ratings.find_or_initialize_by(passage_translation_id: params[:passage_translation_id])
    rating.score = params[:score]

    if rating.save
      head :ok
    else
      render json: { error: rating.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end
end
