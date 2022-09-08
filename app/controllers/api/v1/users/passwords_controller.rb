# frozen_string_literal: true

module Api
    module V1
      module Users
        # password_controller
        class PasswordsController < Devise::PasswordsController
          include ApiResponder
          protect_from_forgery with: :null_session, prepend: true
          skip_before_action :verify_authenticity_token
          respond_to :json
  
          def create
            self.resource = resource_class.send_reset_password_instructions(resource_params)
            yield resource if block_given?
  
            if successfully_sent?(resource)
              render_success({ user: serialized_json(resource) }, I18n.t('devise.passwords.send_instructions'))
            else
              render_error(resource)
            end
          end
  
          def update
            self.resource = resource_class.reset_password_by_token(resource_params)
            yield resource if block_given?
            if resource.errors.empty?
              resource.update(password: params[:api_v1_user][:password], jti: SecureRandom.uuid)
              render_success({ user: serialized_json(resource) }, I18n.t('devise.passwords.updated_not_active'))
            else
              render_error(resource)
            end
          end
  
          private
  
          def resource_params
            params.require(:api_v1_user).permit!
          end
  
          def serialized_json(details)
            UserSerializer.new(details).serializable_hash[:data]
          end
        end
      end
    end
  end
  