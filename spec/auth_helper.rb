module AuthMacros
  def login
    before(:each) do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(ENV['ADDON_USER'], ENV['ADDON_PASSWD'])
    end
  end
end

