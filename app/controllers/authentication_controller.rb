class AuthenticationController < ApplicationController
  def oauth2authorize
    redirect_to user_credentials.authorization_uri.to_s
  end

  def oauth2callback
    user_credentials.code = params[:code] if params[:code]
    user_credentials.fetch_access_token!

    payload = { access_token:  user_credentials.access_token,
                refresh_token: user_credentials.refresh_token,
                expires_in:    user_credentials.expires_in,
                issued_at:     user_credentials.issued_at }

    token = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')

    # Change this url to where Brett would like to capture the token
    redirect_to "http://localhost:3000/settings?token=#{URI.escape(token)}"
  end

  def root
    if params[:token]
      render json: user_api.get_person("me", options: { authorization: @authorization ||= GOOGLE_AUTHORIZATION.dup.tap do |auth|
        auth.redirect_uri = oauth2callback_url
        auth.update_token!(JWT.decode(params[:token], Rails.application.secrets.secret_key_base, true, { algorithm: 'HS256' }).first)
      end }).to_h
    else
      render json: []
    end
  end
end
