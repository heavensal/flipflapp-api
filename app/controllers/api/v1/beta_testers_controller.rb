class Api::V1::BetaTestersController < ApplicationController
  def index
    @beta_testers = BetaTester.all
    render json: @beta_testers, status: :ok
  end

  def create
    @beta_tester = BetaTester.new(beta_tester_params)
    if @beta_tester.save
      render json: @beta_tester, status: :created
    else
      render json: @beta_tester.errors, status: :unprocessable_entity
    end
  end

  private

  def beta_tester_params
    params.require(:beta_tester).permit(:first_name, :last_name, :email, :phone, :favorite_social_network, :social_network_name, :age)
  end
end
