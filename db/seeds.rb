# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def upload_covers(video)
  video.small_cover = File.open(Rails.root.join("public/tmp/" + video.title.downcase.gsub(" ", "_") + ".jpg"))
  video.large_cover = File.open(Rails.root.join("public/tmp/" + video.title.downcase.gsub(" ", "_") + "_large.jpg"))
end

c1 = Category.create(name: 'TV Comedies')
c2 = Category.create(name: 'TV Dramas')

monk = Video.new(title: 'Monk',
                  description: "Adrian Monk is a brilliant San Francisco detective, whose obsessive compulsive disorder just happens to get in the way.",
                  category: c2)
upload_covers(monk)
monk.save

south_park = Video.create(title: 'South Park',
                  description: "Follows the misadventures of four irreverent grade-schoolers in the quiet, dysfunctional town of South Park, Colorado.",
                  category: c1)
upload_covers(south_park)
south_park.save

family_guy = Video.create(title: 'Family Guy',
                  description: "In a wacky Rhode Island town, a dysfunctional family strive to cope with everyday life as they are thrown from one crazy scenario to another.",
                  category: c1)
upload_covers(family_guy)
family_guy.save

futurama = Video.create(title: 'Futurama',
                  description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.",
                  category: c1)
upload_covers(futurama)
futurama.save

alex = User.create(full_name: "Alex Henegar", password: "password", email: "alex@example.com", admin: true)
bob = User.create(full_name: "Bob Henegar", password: "password", email: "bob@example.com")
alice = User.create(full_name: "Alice Henegar", password: "password", email: "alice@example.com")
charlie = User.create(full_name: "Charlie Henegar", password: "password", email: "charlie@example.com")

Relationship.create(leader: bob, follower: alex)

Fabricate.times(20, :review) do
  user { User.all.sample }
  video { Video.all.sample }
end

Review.create(user: alex, video: futurama, rating: 5, content: "This show is the best!")
Review.create(user: alex, video: family_guy, rating: 2, content: "This show could use some work.")

QueueItem.create(user: alex, video: futurama, position: 1)
QueueItem.create(user: alex, video: family_guy, position: 2)
