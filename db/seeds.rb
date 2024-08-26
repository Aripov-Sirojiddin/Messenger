User.create!(name: "Sam Aripov",
             username: "samwake",
             bio: "A riveting biography!",
             email: "aripov86cm@gmail.com",
             password: "samsung",
             password_confirmation: "samsung",
             activated: true,
             activated_at: Time.zone.now,
             admin: true)

# Generate a bunch of additional users.
100.times do |n|
  name = Faker::Name.name
  email = "example-#{n + 1}@example.org"
  username = "awesome_user#{n + 1}"
  password = "password"
  User.create!(name: name,
               username: username,
               bio: "A boring biography",
               email: email,
               password: password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now,)
end

users = User.order(:created_at).take(6)

200.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.microposts.create!(content: content) }
end