Rent.delete_all
Movie.delete_all
User.delete_all
Genre.delete_all
Actor.delete_all
MovieActor.delete_all
MovieGenre.delete_all
actor_1 = Actor.create(:name=>'Robert De Niro')
actor_2 = Actor.create(:name=>'Krstine Bell')
actor_3 = Actor.create(:name=>'Emma Watson')
actor_4 = Actor.create(:name=>'Joaquin Phoenix')
actor_5 = Actor.create(:name=>'Robert Downey Jr')
actor_6 = Actor.create(:name=>'Daniel Radcliffe')
actor_7 = Actor.create(:name=>'Daniel Craig')
actor_8 = Actor.create(:name=>'George MacKay')
actor_9 = Actor.create(:name=>'Scarlet johanson')
actor_10 = Actor.create(:name=>'Song Kang Ho')
actor_11 = Actor.create(:name=>' Elisabeth Moss')

genre_1 = Genre.create(:name=>'Crime')
genre_2 = Genre.create(:name=>'Comedy')
genre_3 = Genre.create(:name=>'Action')
genre_4 = Genre.create(:name=>'Sci_Fi')
genre_5 = Genre.create(:name=>'Animation')
genre_6 = Genre.create(:name=>'Horor')
genre_7 = Genre.create(:name=>'Fantasy')
genre_8 = Genre.create(:name=>'Drama')
genre_9 = Genre.create(:name=>'War')

frozen = Movie.create(name:'Frozen')
irishman = Movie.create(name:'Irishman')
ironman = Movie.create(name:'Ironman')
harrypotter = Movie.create(name:'Harry Potter')
movie1917 = Movie.create(name:'1917')
parasite = Movie.create(name:'Parasite')
knives = Movie.create(name:'Knives Out')
joker = Movie.create(name:'Joker')
jojo = Movie.create(name:'Jojo Rabit')
invisible = Movie.create(name:'The Invisible Man')

movieactor1 = MovieActor.create(movie_id:frozen.id, actor_id:actor_2.id) 
movieactor2 = MovieActor.create(movie_id:irishman.id, actor_id:actor_1.id) 
movieactor3 = MovieActor.create(movie_id:ironman.id, actor_id:actor_5.id) 
movieactor4 = MovieActor.create(movie_id:harrypotter.id, actor_id:actor_3.id) 
movieactor5 = MovieActor.create(movie_id:harrypotter.id, actor_id:actor_6.id) 
movieactor6 = MovieActor.create(movie_id:movie1917.id, actor_id:actor_8.id) 
movieactor7 = MovieActor.create(movie_id:parasite.id, actor_id:actor_10.id) 
movieactor8 = MovieActor.create(movie_id:knives.id, actor_id:actor_7.id) 
movieactor9 = MovieActor.create(movie_id:joker.id, actor_id:actor_4.id) 
movieactor10 = MovieActor.create(movie_id:jojo.id, actor_id:actor_9.id) 
movieactor11 = MovieActor.create(movie_id:invisible.id, actor_id:actor_11.id) 

moviegenre1 = MovieGenre.create(movie_id:frozen.id, genre_id:genre_2.id) 
moviegenre2= MovieGenre.create(movie_id:irishman.id, genre_id:genre_1.id) 
moviegenre3 = MovieGenre.create(movie_id:irishman.id, genre_id:genre_8.id) 
moviegenre4 = MovieGenre.create(movie_id:ironman.id, genre_id:genre_3.id) 
moviegenre5 = MovieGenre.create(movie_id:ironman.id, genre_id:genre_4.id) 
moviegenre6 = MovieGenre.create(movie_id:harrypotter.id, genre_id:genre_7.id) 
moviegenre7 = MovieGenre.create(movie_id:movie1917.id, genre_id:genre_8.id) 
moviegenre8 = MovieGenre.create(movie_id:movie1917.id, genre_id:genre_9.id) 
moviegenre9 = MovieGenre.create(movie_id:parasite.id, genre_id:genre_8.id) 
moviegenre10 = MovieGenre.create(movie_id:knives.id, genre_id:genre_1.id) 
moviegenre11 = MovieGenre.create(movie_id:joker.id, genre_id:genre_1.id) 
moviegenre12 = MovieGenre.create(movie_id:jojo.id, genre_id:genre_8.id) 
moviegenre13 = MovieGenre.create(movie_id:invisible.id, genre_id:genre_6.id) 

# MovieGenre.create()
# actor_3.movies << harrypotter;

# chan = User.create(login_id:'chan', name:'Chan', password:'aaaaa',point:100000)
# jay = User.create(login_id:'jay', name:'Jay', password:'aaaaa',point:200000)



# rent_1 = Rent.create(user_id: chan.id ,movie_id: frozen.id, start_date: '20200302', end_date: '20200309')
# rent_2 = Rent.create(user_id: jay.id, movie_id:irishman.id, start_date: '20200303', end_date: '20200310')

# chan = User.create(login_id:'Chan', password:'1234',point:100000)
# jay = User.create(login_id:'Jay', password:'1234',point:200000)



# frozen.genre = genre_5
# irishman.genre = genre_6
# ironman.genre = genre_1
# harrypotter.genre = genre_7

# genre_5.movies << frozen;
# genre_6.movies << irishman;
# genre_1.movies << ironman;
# genre_7.movies << harrypotter;

# actor_1.movies << irishman;
# actor_2.movies << frozen;
# actor_3.movies << harrypotter;
# # actor_4.movies << actor_1;
# actor_5.movies << ironman;
# actor_6.movies << harrypotter;


# rent_1.user = chan
# rent_2.user = jay

# chan.rents << rent_1
# jay.rents << rent_2

# irishman.rents << rent_2
# frozen.rents << rent_1




