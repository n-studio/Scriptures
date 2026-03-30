module PasskeyCredentials
  class AuthenticationsController < ApplicationController
    def create
      webauthn_credential = WebAuthn::Credential.from_get(params[:credential])
      stored = PasskeyCredential.find_by(external_id: webauthn_credential.id)
      raise ActiveRecord::RecordNotFound, "Passkey not recognized. It may have been removed — try signing in with another method." unless stored

      webauthn_credential.verify(
        session.delete(:webauthn_authenticate_challenge),
        public_key: stored.public_key,
        sign_count: stored.sign_count
      )

      stored.update!(sign_count: webauthn_credential.sign_count)
      start_new_session_for(stored.user)

      render json: { redirect_to: after_authentication_url }
    rescue WebAuthn::Error, ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
