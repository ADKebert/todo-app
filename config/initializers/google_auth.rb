require 'google/apis/calendar_v3'
require 'google/apis/plus_v1'
require 'google/api_client/client_secrets'

Google::Apis::ClientOptions.default.application_name = 'StreamLine To-Do Scheduler'
Google::Apis::ClientOptions.default.application_version = '1.0.0'

GOOGLE_CLIENT_SECRETS = Google::APIClient::ClientSecrets.new({ "web" => { client_id: ENV["GOOGLE_API_CLIENT"] , client_secret: ENV["GOOGLE_API_SECRET"] } })
GOOGLE_AUTHORIZATION = GOOGLE_CLIENT_SECRETS.to_authorization
GOOGLE_AUTHORIZATION.scope = 'https://www.googleapis.com/auth/calendar https://www.googleapis.com/auth/plus.me'

Google::Apis.logger.level = Logger::INFO
