class Api::V1::EventsController < ApplicationController
  before_action :authenticate_user!

  # GET /api/v1/events
  def index
    @events = Event.all
    render json: @events, status: :ok
  end

  # GET /api/v1/events/:id
  def show
    @event = Event.find(params[:id])
    render json: @event, status: :ok
  end

  # POST /api/v1/events
  def create
    @event = current_user.events.build(event_params)
    if @event.save
      render json: @event, status: :created
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # PUT /api/v1/events/:id
  def update
    @event = Event.find(params[:id])
    if @event.update(event_params)
      render json: @event, status: :ok
    else
      render json: @event.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/events/:id
  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    head :no_content
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :location, :start_time, :number_of_participants, :price, :is_private)
  end
end
