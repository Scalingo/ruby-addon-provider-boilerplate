class Scalingo::SsoController < ApplicationController
  def sso
    return redirect_to ENV["DASHBOARD_URL"] if !valid_sso_params?
    return redirect_to ENV["DASHBOARD_URL"] if !valid_token?

    @ep = Endpoint.find_by addon_uid: params[:id]
    @back_url = @ep.dashboard_url
  end

  protected

  def self.generate_authentication_token(id, timestamp)
    Digest::SHA1.hexdigest "#{id}:#{ENV['SSO_SALT']}:#{timestamp}"
  end

  private

  def valid_sso_params?
    params.key?('id') &&
      params.key?('token') &&
      params.key?('timestamp')
  end

  # valid_token? return true if the given timestamp is older than five minutes ago and the given
  # token is valid.
  def valid_token?
    five_minutes_ago = DateTime.now - 5.minutes
    params[:timestamp].to_i > five_minutes_ago.to_i &&
      params[:token] == Scalingo::SsoController.generate_authentication_token(params[:id], params[:timestamp])
  end
end

