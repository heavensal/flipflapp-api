require 'rails_helper'

RSpec.describe "Api::V1::Events", type: :request do
  let(:user) { create(:user) }
  let(:friend) { create(:user) }

  before do
    # Simulate authentication
    allow_any_instance_of(Api::V1::EventsController).to receive(:current_user).and_return(user)
  end

  describe "GET /api/v1/events" do
    let!(:future_public_event) do
      create(:event,
        start_time: 1.day.from_now,
        is_private: false,
        user: create(:user)
      )
    end

    let!(:future_private_event_from_friend) do
      create(:event,
        start_time: 2.days.from_now,
        is_private: true,
        user: friend
      )
    end

    let!(:future_private_event_from_stranger) do
      create(:event,
        start_time: 3.days.from_now,
        is_private: true,
        user: create(:user)
      )
    end

    let!(:past_event) do
      create(:event,
        start_time: 1.day.ago,
        is_private: false,
        user: create(:user)
      )
    end

    before do
      # Create friendship between user and friend
      create(:friendship, user: user, friend: friend, status: 'accepted')

      # Create participants for events (some on teams, some "Sur le Banc")
      create(:participant, event: future_public_event, user: create(:user), team: 'team_a')
      create(:participant, event: future_public_event, user: create(:user), team: 'team_b')
      create(:participant, event: future_public_event, user: create(:user), team: 'bench') # "Sur le Banc"

      create(:participant, event: future_private_event_from_friend, user: create(:user), team: 'team_a')
      create(:participant, event: future_private_event_from_friend, user: create(:user), team: 'bench') # "Sur le Banc"
    end

    context "without filter" do
      it "returns only future events with active participants count" do
        get "/api/v1/events"

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        # Should not include past events
        expect(json_response.length).to eq(3)
        event_ids = json_response.map { |event| event['id'] }
        expect(event_ids).not_to include(past_event.id)

        # Check active participants count (excluding "Sur le Banc")
        public_event_response = json_response.find { |event| event['id'] == future_public_event.id }
        expect(public_event_response['active_participants_count']).to eq(2) # 2 in teams, 1 on bench excluded

        private_friend_event_response = json_response.find { |event| event['id'] == future_private_event_from_friend.id }
        expect(private_friend_event_response['active_participants_count']).to eq(1) # 1 in team, 1 on bench excluded
      end
    end

    context "with public filter" do
      it "returns only public future events" do
        get "/api/v1/events", params: { filter: 'public' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        expect(json_response.length).to eq(1)
        expect(json_response.first['id']).to eq(future_public_event.id)
        expect(json_response.first['is_private']).to be_falsey
        expect(json_response.first['active_participants_count']).to eq(2)
      end
    end

    context "with private filter" do
      it "returns only private events from friends" do
        get "/api/v1/events", params: { filter: 'private' }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)

        # Should only include private events from friends, not from strangers
        expect(json_response.length).to eq(1)
        expect(json_response.first['id']).to eq(future_private_event_from_friend.id)
        expect(json_response.first['is_private']).to be_truthy
        expect(json_response.first['active_participants_count']).to eq(1)

        # Should not include private events from strangers
        event_ids = json_response.map { |event| event['id'] }
        expect(event_ids).not_to include(future_private_event_from_stranger.id)
      end
    end

    context "participants counting" do
      it "only counts participants in teams, not those 'Sur le Banc'" do
        # Add more participants to test the counting logic
        create(:participant, event: future_public_event, user: create(:user), team: 'team_a')
        create(:participant, event: future_public_event, user: create(:user), team: 'team_b')
        create(:participant, event: future_public_event, user: create(:user), team: 'bench') # Should not be counted
        create(:participant, event: future_public_event, user: create(:user), team: 'bench') # Should not be counted

        get "/api/v1/events"

        json_response = JSON.parse(response.body)
        public_event_response = json_response.find { |event| event['id'] == future_public_event.id }

        # Should count 4 team participants, excluding 3 bench participants
        expect(public_event_response['active_participants_count']).to eq(4)
      end
    end

    context "future events filtering" do
      let!(:event_starting_now) { create(:event, start_time: Time.current, is_private: false) }
      let!(:event_starting_in_1_minute) { create(:event, start_time: 1.minute.from_now, is_private: false) }

      it "includes events starting now and in the future" do
        get "/api/v1/events"

        json_response = JSON.parse(response.body)
        event_ids = json_response.map { |event| event['id'] }

        expect(event_ids).to include(event_starting_now.id)
        expect(event_ids).to include(event_starting_in_1_minute.id)
      end
    end
  end
end
