module Sessions
  class VerificationsController < ApplicationController
    def show
    end

    def create
      browser_token = cookies.signed[:browser_token]
      unless browser_token
        redirect_to new_session_path, alert: "Please request a new sign-in link."
        return
      end

      user = MagicToken.find_and_consume_by_code!(params[:code], browser_token: browser_token)
      cookies.delete(:browser_token)
      start_new_session_for user
      redirect_to after_authentication_url
    rescue ActiveRecord::RecordNotFound
      redirect_to session_verification_path, alert: "Invalid or expired code. Please try again."
    end
  end
end
