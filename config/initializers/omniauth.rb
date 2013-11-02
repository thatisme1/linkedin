OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '248977158586283', '5132afd80afc56982efda4b28d399ceb', scope: "email,publish_stream"
end

