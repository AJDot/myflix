require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }


  describe '#recent_videos' do
    it "returns the videos in the reverse chronological order by created_at" do
      comedies = Category.create(name: 'Comedies')

      big_bang_theory = Video.create(title: "Big Bang Theory", description: "Time Travel!", category: comedies, created_at: 1.day.ago)
      bobs_burgers = Video.create(title: "Bob's Burgers", description: "Time Travel!", category: comedies, created_at: 2.day.ago)
      king_of_the_hill = Video.create(title: "King of the Hill", description: "Time Travel!", category: comedies, created_at: 3.day.ago)

      expect(comedies.recent_videos).to eq([big_bang_theory, bobs_burgers, king_of_the_hill])
    end

    it "returns all videos when there are 6 or less videos" do
      comedies = Category.create(name: 'Comedies')
      futurama = Video.create(title: "Futurama", description: "Space!", category: comedies)
      back_to_future = Video.create(title: "Back to Future", description: "Time Travel!", category: comedies)
      expect(comedies.recent_videos.count).to eq(2)
    end

    it "returns 6 when there are 6 or more videos" do
      comedies = Category.create(name: 'Comedies')

      7.times { Video.create(title: "foo", description: "bar", category: comedies)}

      expect(comedies.recent_videos.count).to eq(6)
    end

    it "returns the most recent 6 videos" do
      comedies = Category.create(name: 'Comedies')

      6.times { Video.create(title: "foo", description: "bar", category: comedies)}
      futurama = Video.create(title: "Futurama", description: "Space!", category: comedies, created_at: 1.day.ago)

      expect(comedies.recent_videos).not_to include(futurama)
    end

    it "returns an empty array when there are no videos in the category" do
      comedies = Category.create(name: 'Comedies')
      expect(comedies.recent_videos).to eq([])
    end
  end
end
