# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

example = User.create(name: "Example User", email: "example@example.com", password: "password")
test = User.create(name: "Test User", email: "test@example.com", password: "password")
foo = User.create(name: "Foobar", email: "foobar@example.com", password: "foobar")

example.friend_requests.create(requestee_id: test.id, accepted: true, accepted_on: Time.now)
example.friend_requests.create(requestee_id: foo.id, accepted: false)
