class PasskeyCredentialsController < ApplicationController
  require_authentication

  def create
    webauthn_credential = WebAuthn::Credential.from_create(params[:credential])
    webauthn_credential.verify(session.delete(:webauthn_create_challenge))

    current_user.passkey_credentials.create!(
      external_id: webauthn_credential.id,
      public_key: webauthn_credential.public_key,
      sign_count: webauthn_credential.sign_count,
      label: params[:label].presence || "Passkey"
    )

    render json: { status: "ok" }
  rescue WebAuthn::Error => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def destroy
    current_user.passkey_credentials.find(params[:id]).destroy
    redirect_to account_path, notice: "Passkey removed."
  end
end
