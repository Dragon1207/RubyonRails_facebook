## Users

# login user
User.create(name: "Example User", email: "example@example.com", password: "password")

# random users
9.times {
    User.create(name: Faker::Name.name,
                email: Faker::Internet.unique.email,
                password: Faker::Internet.password)
}

# friend requests
User.all.each do |user|
    people = User.where.not(id: user.id).sample(3)
    people.each do |person|
        if FriendRequest.where("requester_id = :rr_id AND requestee_id = :re_id", rr_id: user.id, re_id: person.id).empty?
            FriendRequest.create(requester: user, requestee: person)
        end
    end
end
# accept friend requests
FriendRequest.all.sample(FriendRequest.count/5*3).each { |f_request|
    f_request.update_attributes( accepted: true,
                                accepted_on: Time.now)
}

# posts
User.all.each do |user|
    10.times do
        p = user.posts.create(text: Faker::Hipster.sentence)
        random_time = rand(10).days.ago
        p.update_attributes(created_at: random_time, updated_at: random_time)
    end
end

# likes

User.all.each do |user|
    feed = user.post_feed
    to_like = feed.sample(rand(feed.length * 8 / 10))
    to_like.each { |post| post.likes.create(user: user) }
end
    