module Sessions
  class MagicTokensController < ApplicationController
    def show
      user = MagicToken.find_and_consume!(params[:token])
      start_new_session_for user
      redirect_to after_authentication_url
    rescue ActiveRecord::RecordNotFound
      redirect_to new_session_path, alert: "Invalid or expired link. Please try again."
    end
  end
end
