class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  # GET /api/v1/users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /api/v1/users/:id
  def show
    @user = User.find(params[:id])
    render json: @user, status: :ok
  end

  def me
    # Returns the current authenticated user
    render json: current_user, status: :ok
  end

  # PUT /api/v1/users/:id
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end
end
