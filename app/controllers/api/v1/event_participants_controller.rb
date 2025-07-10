class Api::V1::EventParticipantsController < ApplicationController
  before_action :authenticate_user!

  # POST /api/v1/event_participants
  def create
    @event_participant = EventParticipant.find_or_initialize_by(
      user: current_user,
      event_id: event_participant_params[:event_id]
    )
    @event_participant.event_team_id = event_participant_params[:event_team_id]

    if @event_participant.save
      render json: @event_participant, status: :ok
    else
      render json: @event_participant.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/event_participants/:id
  def destroy
    @event_participant = EventParticipant.find(params[:id])
    if @event_participant.user == current_user
      @event_participant.destroy
      head :no_content
    else
      render json: { error: "You are not authorized to delete this participant" }, status: :forbidden
    end
  end


  private

  def event_participant_params
    params.require(:event_participant).permit(:event_id, :event_team_id, :user_id)
  end
end
