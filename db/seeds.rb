# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
user = FactoryBot.create(:user, username: 'test', email: 'test@example.com', password: 'secret', password_confirmation: 'secret', first_name: 'Test')
users1 = FactoryBot.create_list(:user, 5)
users2 = FactoryBot.create_list(:user, 5)
user1 = users1.sample
user2 = users2.sample
FactoryBot.create_list(:tweet, 5, user: user1)
FactoryBot.create_list(:tweet, 5, user: user)
tweets = FactoryBot.create_list(:tweet, 5, user: user2)
users1.each do |u|
  FactoryBot.create(:like, user: u, tweet: tweets.sample)
  FactoryBot.create(:follow, user: u, followed: user)
  FactoryBot.create(:follow, user: user, followed: u)
end
10.times do
  FactoryBot.create(:follow, followed: user)
end
file1 = Rails.root.join('app/assets/images/realruby.jpg').open
file2 = Rails.root.join('app/assets/images/rails.png').open
file3 = Rails.root.join('app/assets/images/rubygem.png').open
user.profile_image.attach(io: file1, filename: 'realruby.jpg')
user1.profile_image.attach(io: file2, filename: 'rails.png')
user2.profile_image.attach(io: file3, filename: 'rubygem.png')
