class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  # def session
  #   raise "⛔ SESSION ACCESS DETECTED"
  # end
end
