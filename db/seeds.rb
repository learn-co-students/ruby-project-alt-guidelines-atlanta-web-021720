10.times do 
    Generator.create(username: Faker::Internet.username(specifier: 5..8), email: Faker::Internet.safe_email)
end

10.times do 
    Idea.create(title: Faker::Book.title, post: Faker::Hipster.paragraph, generator_id: Generator.all.sample.id)
end

10.times do
    Implementer.create(username: Faker::Internet.username(specifier: 5..8), email: Faker::Internet.safe_email)
end

10.times do
    Stash.create(idea_id: Idea.all.sample.id, implementer_id: Implementer.all.sample.id)
end