Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV["TWITTER_API_KEY"], ENV["TWITTER_API_SECRET"]
  provider :linkedin, ENV["LINKEDIN_API_KEY"], ENV["LINKEDIN_API_SECRET"], scope: 'r_basicprofile,rw_company_admin'
  provider :google_oauth2,
            ENV["GOOGLE_API_KEY"],
            ENV["GOOGLE_API_SECRET"],
            { access_type: 'online', approval_prompt: '',
              scope: 'http://gdata.youtube.com,userinfo.email https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/analytics.readonly' }
end
