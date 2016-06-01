Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, Rails.application.secrets.twitter_api_key, Rails.application.secrets.twitter_api_secret
  provider :linkedin, Rails.application.secrets.linkedin_api_key, Rails.application.secrets.linkedin_api_secret, scope: 'r_basicprofile,rw_company_admin'
  provider :google_oauth2,
            Rails.application.secrets.google_api_key,
            Rails.application.secrets.google_api_secret,
            { access_type: 'online', approval_prompt: '',
              scope: 'http://gdata.youtube.com,userinfo.email https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/analytics.readonly' }
end
