class ApplicationController < ActionController::API
    include ActionController::RequestForgeryProtection
    protect_from_forgery with: :null_session
    include ActionController::MimeResponds
end
