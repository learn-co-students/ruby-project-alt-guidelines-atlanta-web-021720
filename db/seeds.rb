10.times do 
    User.create(username: Faker::Internet.username(specifier: 5..8), email: Faker::Internet.safe_email, user_type: "Generator")
end

generator_array = []
User.find_each do |user|
    if user.user_type == "Generator"
        generator_array << user
    end
end

10.times do 
    Idea.create(title: Faker::Book.title, post: Faker::Hipster.paragraph, user_id: generator_array.sample.id)
end

10.times do 
    User.create(username: Faker::Internet.username(specifier: 5..8), email: Faker::Internet.safe_email, user_type: "Implementer")
end

implementer_array = []
User.find_each do |user|
    if user.user_type == "Implementer"
        implementer_array << user
    end
end

10.times do
    Stash.create(idea_id: Idea.all.sample.id, user_id: implementer_array.sample.id)
end

10.times do
    Please.create(idea_id: Idea.all.sample.id, user_id: generator_array.sample.id)
end

10.times do 
    Tag.find_or_create_by(tag: Faker::Job.field)
end

10.times do
    IdeaTag.create(tag_id: Tag.all.sample.id, idea_id: Idea.all.sample.id)
end