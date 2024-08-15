User.create!(name: "Sam Aripov",
             username: "samwake",
             bio: "A riveting biography!",
             email: "aripov86cm@gmail.com",
             password:              "samsung",
             password_confirmation: "samsung",
             admin: true)

# Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@example.org"
  username = "awesome_user#{n+1}"
  password = "password"
  User.create!(name: name,
               username: username,
               bio: "A boring biography",
               email: email,
               password:              password,
               password_confirmation: password)
end