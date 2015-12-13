namespace :webchat do
  desc "Create five female users and five male users"
  task generate_users: :environment do
    fem_url = 'https://randomuser.me/api?results=5&gender=female'
    male_url = 'https://randomuser.me/api?results=5&gender=male'
    [fem_url, male_url].each do |url|
      HTTParty.get(url).parsed_response['results'].each do |obj|
        person = obj['user']
        User.create(
          name: "#{person['name']['first']} #{person['name']['last']}",
          email: "#{person['email']}",
          avatar_url: "#{person['picture']['medium']}",
          password: "123456"
        )
      end
    end

    puts "Generated #{User.count} users!"
  end
end
