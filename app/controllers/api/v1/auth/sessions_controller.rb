class Api::V1::Auth::SessionsController < DeviseTokenAuth::SessionsController
  # This controller inherits from DeviseTokenAuth::SessionsController
  # and can be customized further if needed.
  # For example, you can override methods to add custom behavior.

  # Example of overriding a method:
  # def create
  #   super do |resource|
  #     # Custom logic after user session creation
  #   end
  # end
end
