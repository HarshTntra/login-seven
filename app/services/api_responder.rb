# frozen_string_literal: true

module ApiResponder
    def success_json(data, message = '')
      data.merge(message: message, success: true)
    end
  
    def success_json_with_params(data, message = '', record_params = {})
      data.merge(message: message, success: true).merge!(record_params)
    end
  
    def error_json(detail)
      {
        errors: errors(detail),
        success: false
      }
    end
  
    def render_success(data, message = '', record_params = {})
      json_data = if record_params.empty?
                    success_json(data, message)
                  else
                    success_json_with_params(data,
                                             message, record_params)
                  end
      render json: json_data, status: 200
    end
  
    def render_error(data)
      render json: error_json(data), status: 200
    end
  
    private
  
    def errors(detail)
      return detail if detail.is_a? String
  
      detail.errors.full_messages.join(', ')
    end
  end
  