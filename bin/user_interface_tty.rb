require 'bundler'
Bundler.require
system "clear"

#-------------------------------------intro & login function---------------------------------------------#
def tty_home 

    system 'clear'
    print "
    ######                                                                           #####    ###    #####    ###   
    #     # #       ####   ####  #    # #####  #    #  ####  ##### ###### #####     #     #  #   #  #     #  #   #  
    #     # #      #    # #    # #   #  #    # #    # #        #   #      #    #          # #     #       # #     # 
    ######  #      #    # #      ####   #####  #    #  ####    #   #####  #    #     #####  #     #  #####  #     # 
    #     # #      #    # #      #  #   #    # #    #      #   #   #      #####     #       #     # #       #     # 
    #     # #      #    # #    # #   #  #    # #    # #    #   #   #      #   #     #        #   #  #        #   #  
    ######  ######  ####   ####  #    # #####   ####   ####    #   ###### #    #    #######   ###   #######   ###                                                                                                                          
    ".colorize(:blue)                                                                                                                     
     
        
        TTY::Prompt.new.select("Welcome to Blockbuster 2020!") do |menu|
            menu.choice "I'm actually a user here (login)" => -> do tty_login end
            menu.choice "Hey there! Create login id (new user)" => -> do tty_create_user end
            menu.choice "Exit Blockbuster 2020" => -> do tty_exit end
        end
        
end

def tty_login 
    $login_id = TTY::Prompt.new.ask("Oh welcome back, what was your id?")
    if User.find_by(login_id: $login_id) == nil 
        puts "Sorry, couldn't find you on our list."
        # tty_create_user
        tty_to_create_user_menu("try more?",&method(:tty_login))
    else  
        tty_password    
    end
end

def tty_create_user 
    $login_id = TTY::Prompt.new.ask("What's your new id?")
    # $password = TTY::Prompt.new.ask("What's your password buddy?")
    if User.find_by(login_id: $login_id)
        puts "Id exists"
        tty_create_user
    else
        prompt = TTY::Prompt.new
        heart = prompt.decorate(prompt.symbols[:heart] + ' ', :magenta)

        $password  = prompt.mask("What's your password?", mask: heart) do |q|
            q.validate(/[a-z\ ]{5,15}/)
        end 
        
    
        $customer = User.create(login_id: $login_id, password: $password) 
        tty_main_menu
    end
end

def tty_password
    prompt = TTY::Prompt.new
    heart = prompt.decorate(prompt.symbols[:heart] + ' ', :magenta)
    $password  = prompt.mask("What's your password?", mask: heart)
    $customer = User.find_by(login_id: $login_id, password:$password ) 
    if $customer == nil 
        puts "Sorry, password is wrong."
        tty_password    
    else
        tty_main_menu
    end 
end
#--------------------------------main menu function---------------------------------------------#
def tty_main_menu 
    system 'clear'
    $customer.reload
    TTY::Prompt.new.select("Would you like to...", active_color: :blue) do |menu|
        menu.choice "1. Try our videos?" => -> do tty_list_moives end
        menu.choice "2. Find movie?" => -> do tty_find_movie end
        menu.choice "3. Rent movie list?" => -> do tty_all_rent_list end
        menu.choice "4. Change User Password" => -> do tty_change_password end
        menu.choice "5. Delete account?" => -> do tty_delete_acount end
        menu.choice "6. Exit Blockbuster 2020" => -> do tty_exit end
            
    end
    
end
# Main Menu 1
def tty_list_moives 
    movie_list = []
    item_hash = {}
    TTY::Prompt.new.multi_select("Select movies:", filter: true, active_color: :red) do |menu|
        Movie.all.each do |movie|
                            
            item_label = tty_make_menu_item(movie.name, movie.all_actor_names, movie.all_genre_names)

            item_hash = { item_label => -> do
                Rent.create(user_id: $customer.id ,movie_id: movie.id, start_date: '20200304', end_date: '20200403', return: false)
                movie_list << movie
                end}

            rent_user = Rent.find_by(movie_id: movie.id)
            #binding.pry
            if rent_user != nil && rent_user.get_user_id == $customer.id    
                # binding.pry
                item_hash.merge!(disabled:'(rented)')
                # binding.pry
            end

            # item_hash = {name: 'sake', disabled: '(out of stock)'}
            menu.choice item_hash
        end               
    end

    if movie_list.length > 0
        tty_rent_list(movie_list,"Titles are rented!!")            
    else
        puts "No movie seleted!!"
        tty_to_main_menu(&method(:tty_list_moives))
    end

    # tty_to_main_menu
end
# Main Menu 2
def tty_find_movie
    name = TTY::Prompt.new.ask("Search your movie!!")
    if Movie.find_by(name: name)
        puts "#{name} is  exists"            
    else
        puts "No movie found!!"
    end
    tty_to_main_menu(&method(:tty_find_movie))
end
# Main Menu 3
def tty_all_rent_list
    rent_list = []
    if Rent.get_rent_count($customer) > 0
        TTY::Prompt.new.multi_select("Select movies to return: or just return", filter: true, active_color: :red) do |menu|
            Rent.all.each do |rent|
                if rent.get_user_id != nil && rent.get_user_id == $customer.id && rent.get_state =="rent"
                # if rent.get_user_id != nil && rent.get_user_id == $customer.id
                    menu.choice rent.get_movie_name => -> do 
                        rent.update(return: true) 
                        rent_list << rent    
                    end
                end
            end               
        end            
    end

    if rent_list.length > 0
        tty_return_list(rent_list,"All videos are returned.")
    else
        puts "No movie rented!!"
    end

    tty_to_main_menu(&method(:tty_all_rent_list))               
end

# Main Menu 4
def tty_change_password
    user = User.find_by(login_id: $login_id)
    if user
        password = TTY::Prompt.new.ask("Input new password!!")
        user.update(password: password)
    end
    puts "Your account password changed. Please login again!!!"
    exit
end
# Main Menu 5
def tty_delete_acount
    user = User.find_by(login_id: $login_id)
    prompt = TTY::Prompt.new

    answer = prompt.yes?('Do you reallay want to delete?')
    if answer
        if user
            user.destroy
        end
        puts "Your account is deleted. Bye!!!"
        exit
    else
        tty_main_menu
    end
end

# Main Menu 6
def tty_exit
    print " 

    ####### #          #    ####### ### ######  ####### #     #     #####   #####  #     # ####### ####### #       
    #       #         # #      #     #  #     # #     # ##    #    #     # #     # #     # #     # #     # #       
    #       #        #   #     #     #  #     # #     # # #   #    #       #       #     # #     # #     # #       
    #####   #       #     #    #     #  ######  #     # #  #  #     #####  #       ####### #     # #     # #       
    #       #       #######    #     #  #   #   #     # #   # #          # #       #     # #     # #     # #       
    #       #       #     #    #     #  #    #  #     # #    ##    #     # #     # #     # #     # #     # #       
    #       ####### #     #    #    ### #     # ####### #     #     #####   #####  #     # ####### ####### #######
    
    ###    #####    #   #######  #####    ###   
    #   #  #     #  ##   #    #  #     #  #   #  
    #     #       # # #       #         # #     # 
    #     #  #####    #      #     #####  #     # 
    #     # #         #     #     #       #     # 
    #   #  #         #     #     #        #   #  
        ###   ####### #####   #     #######   ###   
    ".colorize(:red)
    exit
end

# Helper Function - List rent movie
def tty_rent_list(movies, message)
    index = 1
    puts "====Rent List===="
    puts "No. Title"
    movies.each do |movie|
        puts index.to_s + ".  " + movie.name
        index = index + 1  
    end
    if index == 1
        puts("No Data Exist!!")
    else
        # puts("Titles are rented!!\n")
        puts("#{message}")    
    end       
    tty_to_main_menu(&method(:tty_list_moives))
end

# Helper Function - List return movie
def tty_return_list(rents, message)
    index = 1
    puts "====Return List===="
    puts "No. Title"
    rents.each do |rent|
        puts index.to_s + ".  " + rent.get_movie_name
        index = index + 1  
    end
    if index == 1
        puts("No Data Exist!!")
    else
        # puts("Titles are rented!!\n")
        puts("#{message}")    
    end       
    tty_to_main_menu(&method(:tty_all_rent_list))
end

#----------------------------------------Helper Function--------------------------------------# 

#make menu list item @args : movie_name , actor_names - actor_name array 
def tty_make_menu_item(movie_name,actor_names, genre_names)        
    # binding.pry 
    #actor_names = movie.all_actor_names 
    item_label =  movie_name + " ( actor :"
    actor_names.flatten.each do |name| 
        item_label = item_label + " " + name
        if(actor_names.last != name)
            item_label = item_label + " and"
        else
            item_label = item_label + ","     
        end
    end

    item_label = item_label + " genre :"
    genre_names.flatten.each do |name| 
        item_label = item_label + " " + name
        if(genre_names.last != name)
            item_label = item_label + " and"
        else
            item_label = item_label + " )"     
        end
    end

    item_label            
end
#Ask to move back to main menu or exit
def tty_to_main_menu(&func) 
    prompt = TTY::Prompt.new

    answer = prompt.yes?('Do you want to move to main menu?')

    if answer
        tty_main_menu
    else
        if func    
            func.call
        else
            exit
        end
    end
end
#Ask to try login more or move to create_user menu
def tty_to_create_user_menu(message, &stay_func) 
    prompt = TTY::Prompt.new
    answer = prompt.yes?(message)
    if answer
        stay_func.call
    else
        if stay_func    
            tty_create_user
        else
            exit
        end
    end
end