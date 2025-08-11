class Api::V1::FriendshipsController < ApplicationController
  # before_action :authenticate_user!

  def index
    @friendships = current_user.friendships.includes(:sender, :receiver)
    render json: @friendships, status: :ok
  end

  def create
    @friendship = current_user.friendships.build(friendship_params)
    if @friendship.save
      render json: @friendship, status: :created
    else
      render json: @friendship.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    @friendship.destroy
    head :no_content
  end

  private

  def friendship_params
    params.require(:friendship).permit(:receiver_id)
  end
end
