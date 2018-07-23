OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, ENV['GOOGLE_ID'], ENV['GOOGLE_SECRET'], {name: 'google', client_options: {ssl: {ca_file: Rails.root.join("cacert.pem").to_s}}, setup: (lambda do |env| request = Rack::Request.new(env) 
            env['omniauth.strategy'].options['token_params'] = {:redirect_uri => 'https://e9dc7959c037402a90af6fe26e199e61.vfs.cloud9.us-east-2.amazonaws.com/auth/google/callback'}  
        end)}
end