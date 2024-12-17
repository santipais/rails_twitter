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
FactoryBot.create_list(:tweet, 5, user: users1.sample)
FactoryBot.create_list(:tweet, 5, user: user)
tweets = FactoryBot.create_list(:tweet, 5, user: users2.sample)
users1.each do |u|
  FactoryBot.create(:like, user: u, tweet: tweets.sample)
  FactoryBot.create(:follow, user: u, followed: user)
  FactoryBot.create(:follow, user: user, followed: u)
end
10.times do
  FactoryBot.create(:follow, followed: user)
end
