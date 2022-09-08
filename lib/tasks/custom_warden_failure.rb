# frozen_string_literal: true

class CustomWardenFailure < Devise::FailureApp
    def respond
      if request.format == :json
        json_failure
      else
        super
      end
    end
  
    def json_failure
      self.status = 200
      self.content_type = 'application/json'
      self.response_body = if warden_message == 'revoked token' || warden_message == 'wrong scope'
                             { success: false, errors: error_message }.merge(logout: true).to_json
                           else
                             self.response_body = { success: false, errors: error_message }.to_json
                           end
    end
  
    private
  
    def error_message
      case warden_message
      when :unconfirmed
        I18n.t('devise.failure.unconfirmed')
      when :inactive
        I18n.t('messages.inactive_user')
      else
        I18n.t('messages.invalid_login')
      end
    end
  end
  