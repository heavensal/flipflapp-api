class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save
    if resource.persisted?
      render json: {
        message: "Signed up",
        token: JsonWebToken.encode(user_id: resource.id),
        user: UserSerializer.new(resource).serializable_hash
      }, status: :ok
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      @token = request.env["warden-jwt_auth.token"]
      headers["Authorization"] = @token

      render json: {
        status: { code: 200, message: "Signed up successfully.",
                  token: @token,
                  data: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
      }
    else
      render json: {
        status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end
end
