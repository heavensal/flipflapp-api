class Api::V1::EventTeamsController < ApplicationController
  before_action :authenticate_user!

  # PUT /api/v1/event_teams/:id
  def update
    @event_team = EventTeam.find(params[:id])
    if @event_team.update(event_team_params)
      render json: @event_team, status: :ok
    else
      render json: @event_team.errors, status: :unprocessable_entity
    end
  end

  private

  def event_team_params
    params.require(:event_team).permit(:name, :event_id)
  end
end
