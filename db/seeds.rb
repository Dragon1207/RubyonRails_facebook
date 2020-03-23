## Users

# login user
User.create(name: "Hugh Mann", email: "demo@example.org", password: "demodemo")

# random users
9.times {
    User.create(name: Faker::Name.unique.name,
                email: Faker::Internet.unique.email,
                password: Faker::Internet.password)
}

# friend requests
User.all.each do |user|
    people = user.strangers.sample(3)
    people.each do |person|
        if person.strangers.include?(user)
            FriendRequest.create(requester: user, requestee: person)
        end
    end
end
# accept friend requests
FriendRequest.all.sample(FriendRequest.count/5*3).each { |f_request|
    f_request.update_attributes( accepted: true,
                                accepted_on: Time.now)
}

## Posts
User.all.each do |user|
    10.times do
        p = user.posts.create(text: Faker::Hipster.sentence)
        random_time = rand(10).days.ago - rand(12).hours - rand(60).minutes 
        p.update_attributes(created_at: random_time, updated_at: random_time)
    end
end

# likes
User.all.each do |user|
    feed = user.post_feed
    to_like = feed.sample(rand(feed.length * 8 / 10))
    to_like.each { |post| post.likes.create(user: user) }
end

# comments
User.all.each do |user|
    feed = user.post_feed.load
    some_posts = feed.sample(feed.size/2)
    some_posts.each do |post|
        random_time = post.created_at + rand(5).days + rand(24).hours + rand(60).minutes 
        comment = post.comments.create(author: user, text: Faker::Movie.quote)
        comment.update_attributes(created_at: random_time, updated_at: random_time)
    end
end
         