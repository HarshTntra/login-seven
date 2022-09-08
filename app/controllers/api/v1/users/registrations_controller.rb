# frozen_string_literal: true

module Api
    module V1
      module Users
        class RegistrationsController < Devise::RegistrationsController
          include ApiResponder
          protect_from_forgery with: :null_session, prepend: true
          skip_before_action :verify_authenticity_token, only: :create
          respond_to :json
  
          def create
            self.resource = resource_class.create(sign_up_params)
            yield resource if block_given?
  
            if resource.save
              render_success({ user: serialized_json(resource) }, I18n.t('devise.registrations.signed_up'))
            else
              render_error(resource)
            end
          end
  
          private
  
          def sign_up_params
            params.require(:api_v1_user).permit(:email, :password, profile_attributes:
              %i[name])
          end
  
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
  