module UsersHelper
  # def ajax_redirect_to(redirect_uri)
  #   { js: "window.location.replace('#{redirect_uri}');" }
  # end

  def get_recaptcha_response(token)
    siteverify_uri = URI.parse("https://www.google.com/recaptcha/api/siteverify?response=#{token}&secret=#{Rails.application.credentials.recaptcha[:recaptcha_secret_key]}")
    response = Net::HTTP.get_response(siteverify_uri)
    json_response = JSON.parse(response.body)
  end
end
