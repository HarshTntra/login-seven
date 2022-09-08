# frozen_string_literal: true

module Api
    module V1
      module Users
        # Session contoller
        class SessionsController < Devise::SessionsController
          include ApiResponder
  
          protect_from_forgery with: :null_session, prepend: true
          skip_before_action :verify_authenticity_token
          skip_before_action :verify_signed_out_user
          respond_to :json
  
          def create
            # Devise.mappings[:user] = Devise.mappings[:api_v1_user]
            # warden.config[:default_strategies][:user] = warden.config[:default_strategies].delete(:api_v1_user)
            # auth_opts = auth_options
            # auth_opts[:scope] = :user
            if self.resource = warden.authenticate
              sign_in(User, resource)
              render_success({ user: serialized_json(resource) }, I18n.t('devise.sessions.signed_in'))
            else
              render_error(I18n.t('devise.failure.invalid', authentication_keys: 'email'))
            end
          end
  
          def destroy
            signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
            if signed_out
              render_success({ user: serialized_json(resource) }, I18n.t('devise.sessions.signed_out'))
            else
              render_error(I18n.t('errors.messages.unable_to_sign_out'))
            end
          end
  
          private
  
          def serialized_json(details)
            UserSerializer.new(details).serializable_hash[:data]
          end
        end
      end
    end
  end
  