Fabricator(:user) do
  email { Faker::Internet.email }
  password 'password'
  full_name { Faker::Name.name.gsub("'", "") }
  admin false
  active true
end

Fabricator(:admin, from: :user) do
  admin true
end
