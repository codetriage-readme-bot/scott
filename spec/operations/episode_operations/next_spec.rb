require "rails_helper"

RSpec.describe EpisodeOperations::Next, type: :operation do
  let(:channel) { Fabricate(:channel, title: "Foo") }
  let(:episode) { episodes.third }
  let(:episodes) do
    [
      Fabricate(:episode, title: "Episode 005", published_at: 1.days.ago, channel: channel),
      Fabricate(:episode, title: "Episode 004", published_at: 2.days.ago, channel: channel),
      Fabricate(:episode, title: "Episode 003", published_at: 3.days.ago, channel: channel),
      Fabricate(:episode, title: "Episode 002", published_at: 4.days.ago, channel: channel),
      Fabricate(:episode, title: "Episode 001", published_at: 5.days.ago, channel: channel),
    ]
  end
  let(:operation) { run(EpisodeOperations::Next, uuid: episode.uuid) }
  let(:next_episode) { operation }

  describe "next" do
    context "when there are other episodes for the channel" do
      context "and there are recentest episode" do
        it "returns the next published episode" do
          expect(next_episode).to eq(episodes.second)
        end
      end
    end

    context "when there are no other episodes for the same channel" do
      let!(:other_channel) { Fabricate(:channel_with_episodes) }
      let(:episode) { Fabricate(:episode, channel: channel) }

      it "returns a random episode from other channel" do
        expect(next_episode).to be_an_instance_of(Episode)
      end

      it "does not returns the same episode" do
        expect(next_episode.id).to_not eq(episode.id)
      end
    end

    context "when there are no other episodes at all" do
      let(:episode) { Fabricate(:episode, channel: channel) }

      it "returns nil" do
        expect(next_episode).to be_nil
      end
    end
  end
end
