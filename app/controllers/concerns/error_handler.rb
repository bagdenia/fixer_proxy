module ErrorHandler
  def self.included(clazz)
    clazz.class_eval do
      rescue_from StandardError do |e|
        respond(:standard_error, 500, e.to_s)
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        respond(:record_not_found, 404, e.to_s)
      end

      rescue_from ActionController::ParameterMissing do |e|
        respond(:parameter_missing, 400, e.to_s)
      end
    end
  end

  private

  def respond(error, status, message)
    json = Errors::Render.json(error, status, message)
    render json: json, status: status
  end
end
