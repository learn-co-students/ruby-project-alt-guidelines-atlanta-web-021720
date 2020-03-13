


class CommandLineInterface

    def run_program
        prompt = TTY::Prompt.new
        system 'clear'
        greet
        landing_page   
        log_in_or_create?
        run_gen_or_imp_prompts
    end

    def greet
        give_space
        puts "               \\   \\  \\ | || | /  /   /    "
        puts "   Welcome to    T H I N K   T A N K       "
        puts "               /   /  / | || | \\  \\   \\    "
        give_space
    end

    def landing_page
        prompt = TTY::Prompt.new
        give_space
        response = prompt.yes?("Ready to explore Think Tank?")
        if response == false
            log_out
        end
    end

    def log_in_or_create?
        system "clear"
        prompt = TTY::Prompt.new
        give_space
        user_type = prompt.select("Log in or create new user?", (["Create new", "Log in"]))
        if user_type == "Create new"
            give_space
            puts "Here at think tank, we have two different kinds of users."
            puts "A Generator is someone who creates ideas and posts them to share with others."
            puts "An Implementer is someone looking for ideas to build or produce."
            create_response = prompt.select("What would you like to do now?", (["Create Generator Account - I have ideas", "Create Implementer Account - I need ideas", "I already have an account", "Nevermind, I'm done with Think Tank"]))
            if create_response == "Create Generator Account - I have ideas"
                create_generator_account
                if @user == nil
                    log_in_or_create?
                end
            elsif create_response == "Create Implementer Account - I need ideas"
                create_implementer_account
            elsif create_response == "I already have an account"
                login
            elsif create_response == "Nevermind, I'm done with Think Tank"
                log_out
            end
        else
            give_space
            puts "Hey there, you! Welcome back."
            login
        end
        run_gen_or_imp_prompts
    end

    def run_gen_or_imp_prompts
        if @user.user_type == "Generator"
            generator_prompt
        elsif @user.user_type == "Implementer"
            implementer_prompt
        end
        run_gen_or_imp_prompts
    end


##############################################################################################
##############################################################################################
    #log_in_or_create? 

    def create_generator_account
        system "clear"
        prompt = TTY::Prompt.new
        give_space
        puts "Okay! We can make a Generator account for you."
        username = prompt.ask("Create a username:") do |q|
            q.modify :trim
        end
        if User.find_by(username: username)
            give_space
            give_space
            puts "***\\ \\ \\             ***!!!!***             / / /***"
            puts "***There is already a username with that account!***"
            puts "Please log in or pick a different name."
            prompt.keypress("Press any key to try again.")
        else
            email = prompt.ask("What is your email address?") do |q|
                q.modify :trim
            end
            @user = User.create(username: username, email: email, user_type: "Generator")
            system "clear"
            puts "Account created!"
            give_space
            puts "First, a quick intro:"
            puts "As a generator, you can post new ideas."
            puts "If you want to edit an idea, go to 'View your ideas'."
            give_space
            prompt.keypress("Got it? Press any key.")
            give_space
        end
    end

    def create_implementer_account
        prompt = TTY::Prompt.new
        system "clear"
        give_space
        puts "Okay! We can make an Implementer account for you."
        username = prompt.ask("Create a username:") do |q|
            q.modify :trim
        end
        if User.find_by(username: username)
            give_space
            give_space
            puts "***\\ \\ \\             ***!!!!***             / / /***"
            puts "***There is already a username with that account!***"
            puts "Please log in or pick a different name."
            landing_page
            log_in_or_create?
        else
            email = prompt.ask("What is your email address?") do |q|
                q.modify :trim
            end
            @user = User.create(username: username, email: email, user_type: "Implementer")
            system "clear"
            puts "Account created!"
            give_space
            puts "First, a quick intro:"
            puts "As an implementor, you can view ideas."
            puts "If you want to save one for later, just add it to your stash."
            give_space
            prompt.keypress("Got it? Press any key.")
            give_space
        end
    end

    def login
        prompt = TTY::Prompt.new
        give_space
        give_space
        give_space
            @user = nil
            while @user == nil do
                username_response = prompt.ask("Enter your username (case-sensitive):")
                @user = User.find_by(username: username_response) do |q|
                    q.modify :trim
                end
                break if @user
                retry_response = prompt.yes?("Invalid username. Try again?")
                if retry_response == false
                    greet
                    landing_page
                    log_in_or_create?
                end
            end
        run_gen_or_imp_prompts
    end


####################################################################################################
    #generator_prompts

    def generator_prompt
        prompt = TTY::Prompt.new
        system "clear"
        give_space
        puts "Welcome, Generator #{@user.username}."
        choices = ["Browse ideas", "Post an idea", "Log out of my account", "Log out of Think Tank"]
        selection = prompt.select("What would you like to do today?", (choices))
            if selection == choices[0]
                generator_browse_menu
            elsif selection == choices[1]
                post_idea
            elsif selection == choices[2]
                greet
                landing_page
                log_in_or_create?
            elsif selection == choices[3]
                log_out
            end
        give_space
        generator_prompt
    end
####################################
    def generator_browse_menu
        prompt = TTY::Prompt.new
        system "clear"
        choices = ["View your Ideas", "View 'Yes, Please!' list", "Browse all Ideas", "Browse Ideas by Cateogry", "Search Ideas by Keyword", "Return to Main Menu"]
        response = prompt.select("", (choices))
        if response == choices[0]
            view_own_ideas
        elsif response == choices[1]
            view_pleases
        elsif response == choices[2]
            generator_browse_all
        elsif response == choices[3]
            browse_by_category
        elsif response == choices[4]
            search_ideas_by_keyword
        elsif response == choices[5]
            generator_prompt
        end
        generator_browse_menu
    end

    def generator_browse_all
        prompt = TTY::Prompt.new
        system "clear"
        Idea.find_each do |idea|
            print_idea_with_generator(idea)
            response = prompt.select("View next idea, 'Yes, Please!', or Quit browsing.", (["Next", "Yes, Please!", "Quit"]))
            break if response == "Quit"
            if response == "Yes, Please!"
                create_please(idea)
            end
        end
        generator_browse_menu
    end

    def browse_by_category
        prompt = TTY::Prompt.new
        system "clear"
        give_space
        give_space
        response = prompt.select("Select Category", (idea_categories))
        category_array = Idea.where(category: response)
        if category_array == []
            puts "There are no ideas in that category!"
            give_space
            give_space
            give_star_divider
        else
            category_array.each do |idea|
                print_idea_with_generator(idea)
                if @user.user_type == "Generator"
                    response = prompt.select("View next idea, 'Yes, Please!', or Quit browsing.", (["Next", "Yes, Please!", "Quit"]))
                    break if response == "Quit"
                    if response == "Yes, Please!"
                        create_please(idea)
                    end
                else
                    response = prompt.select("View next idea, Stash idea, or Quit browsing.", %w(Next Stash Quit))
                    break if response == "Quit"
                    if response == "Stash"
                        stash_idea(idea)
                    end
                end
            end
        end
    end
        
    def create_please(idea)
        system "clear"
        prompt = TTY::Prompt.new
        give_space
        give_space
        puts "Saving..."
        Please.create(user_id: @user.id, idea_id: idea.id)
        id = @user.id
        @user = User.find(id)
        give_space
        give_space
        prompt.keypress("Good eye- We've saved that idea to your 'Yes, Please!' list.\n\n That idea is sure to be the next big thing.\n\nPress any key to continue...", timeout: 3)
    end
###################################
    def view_own_ideas
        system "clear"
        prompt = TTY::Prompt.new
        if @user.ideas.count == 0
            give_star_divider
            3.times do 
                give_space 
            end
            prompt.keypress("You haven't shared any ideas yet!", timeout: 3)
        else
            @user.ideas.each do |idea|
                print_idea_without_generator(idea)
                response = prompt.select("View next, Edit current idea, or quit browsing", %w(Next Edit Quit))
                if response == "Edit"
                    edit_idea(idea)
                end
                break if response == "Quit"
            end
        end
    end

    def edit_idea(idea)
        #called by view_own_ideas
        prompt = TTY::Prompt.new
        system "clear"
        give_star_divider
        give_space
        title = prompt.ask("Please enter the updated idea name", value: idea.title)
        give_space
        post = prompt.ask("Please enter the updated idea description", value: idea.post)
        give_space
        category = prompt.select("Category?", (idea_categories))
        puts "saving..."
        idea.title = title
        idea.post = post
        idea.category = category
        idea.save
        id = @user.id
        @user = User.find(id)
        give_space
        give_space
        prompt.keypress("Edits saved! \n\nPress any key to continue...", timeout: 3)
    end

#######################################
    def view_pleases
        system "clear"
        prompt = TTY::Prompt.new
        if @user.pleases.count == 0
            give_star_divider
            3.times do 
                give_space
            end
            prompt.keypress("You haven't said 'Yes, Please!' to any ideas yet!", timeout: 3)
        else
            @user.pleases.each do |please|
                print_idea_without_generator(please.idea)
                response = prompt.select("View next, Remove current idea, or quit browsing", %w(Next Remove Quit))
                if response == "Remove"
                    delete_please(please)
                    give_space
                    give_space
                end
                break if response == "Quit"
            end
        end
    end

    def delete_please(please)
        prompt = TTY::Prompt.new
        give_space
        puts "Removing..."
        please.destroy
        id = @user.id
        @user = User.find(id)
        give_space
        give_space
        prompt.keypress("All done! This idea has been removed from your list. 
        Press any key to continue...", timeout: 3)  
    end
######################################
    def search_ideas_by_keyword
        system "clear"
        prompt = TTY::Prompt.new
        give_star_divider
        give_space
        response = prompt.ask("Enter the word you would like to search by:(one word)")
        lc_response = response.downcase
        give_space
        puts "Preparing your results..."
        keyword_ideas = []
        Idea.find_each do |idea|
            if idea.title.downcase.include? lc_response
                keyword_ideas << idea
            end
        end
        if keyword_ideas.count == 0
            puts "No ideas found with #{response} in the title."
        else
            if @user.user_type == "Generator"
                keyword_ideas.each do |idea|
                    if idea.user == self
                        print_idea_with_generator(idea)
                        response = prompt.select("View next, edit, or quit browsing. \nThis awesome idea belongs to you, so you can't add it to your 'Yes, Please!' list.", %w(Next Edit Quit))
                        break if response == "Quit"
                        if response == "Edit"
                            edit_idea(idea)
                        end
                    else
                    print_idea_with_generator(idea)
                    response = prompt.select("View next idea, 'Yes, Please!', or Quit browsing.", (["Next", "Yes, Please!", "Quit"]))
                    break if response == "Quit"
                        if response == "Yes, Please!"
                            create_please(idea)
                        end
                    end
                end
            elsif @user.user_type == "Implementer"
                keyword_ideas.each do |idea|
                    print_idea_with_generator(idea)
                    response = prompt.select("View next idea, Stash idea, or Quit browsing.", %w(Next Stash Quit))
                    break if response == "Quit"
                    if response == "Stash"
                        stash_idea(idea)
                    end
                end
            end
        end
    end


#####################################
    def idea_categories
        @idea_categories = ["Entertain", "Utility", "Business", "Creative", "Other"]
        @idea_categories
    end

    def post_idea
        system "clear"
        prompt = TTY::Prompt.new
        give_star_divider
        give_space
        confirmation = nil
        title = prompt.ask("Please enter a name for your idea:", required: true)
        give_space
        post = prompt.ask("Great! Now describe your idea.", required: true)
        give_space
        category = prompt.select("Please select the category that best fits.", (idea_categories))
        give_space
        give_star_divider
        give_space
        confirmation = prompt.yes?("Idea title: #{title}\n\nIdea: #{post} \n\nCategory: #{category}\n\nDoes this look right?")
        if confirmation == false
            give_space
            title = prompt.ask("Please edit your idea name", required: true, value: title)
            give_space
            post = prompt.ask("Great! Now edit your idea, or press enter.", required: true, value: post)
            give_space
            category = prompt.select("Okay, category?", (idea_categories))
            give_space
        end
        give_space
        give_space
        puts "saving..."
        idea = Idea.create(title: title, post: post, user_id: @user.id, category: category)
        id = @user.id
        @user = User.find(id)
        give_space
        give_space
        prompt.keypress("Thanks, Generator #{@user.username}! What an awesome idea. \nIf you decide to edit your idea, you may do so by viewing your ideas. \n\nPress any key to continue...", timeout: 3)
    end



########################################################################################################
    #implementer_prompts

    def implementer_prompt
        prompt = TTY::Prompt.new
        system "clear"
        give_space
        puts "Welcome, Implementer #{@user.username}."
        choices = ["Browse ideas", "Log out of my account", "Log out of Think Tank"]
        selection = prompt.select("What would you like to do today?", (choices))
            if selection == choices[0]
                implementer_browse_menu
            elsif selection == choices[1]
                greet
                landing_page
                log_in_or_create?
            elsif selection == choices[2]
                log_out
            end
        give_space
        implementer_prompt
    end


#####################################
    def implementer_browse_menu
        system "clear"
        prompt = TTY::Prompt.new
        choices = ["View your Stashes", "Browse all Ideas", "Browse Ideas by Category", "Search Ideas by Keyword", "Return to Main Menu"]
        response = prompt.select("", (choices))
        if response == choices[0]
            view_stashes
        elsif response == choices[1]
            implementer_browse_all
        elsif response == choices[2]
            browse_by_category
        elsif response == choices[3]
            search_ideas_by_keyword
        elsif response == choices[4]
            implementer_prompt
        end
        implementer_browse_menu
    end


    def implementer_browse_all
        system "clear"
        prompt = TTY::Prompt.new
        Idea.find_each do |idea|
            print_idea_with_generator(idea)
            response = prompt.select("View next idea, Stash this idea, or quit browsing.", %w(Next Stash Quit))
            if response == "Stash"
                stash_idea(idea)
            end
            break if response == "Quit"
        end
    end

    def stash_idea(idea)
        system "clear"
        prompt = TTY::Prompt.new
        give_space
        puts "stashing..."
        Stash.create(user_id: @user.id, idea_id: idea.id)
        id = @user.id
        @user = User.find(id)
        give_star_divider
        give_space
        give_space
        prompt.keypress("Success! Kudos for stashing a great idea. 
        Press any key to continue, resumes automatically in 3 seconds ...", timeout: 3)
        give_space
        give_space
    end

####################################
    def view_stashes
        system "clear"
        prompt = TTY::Prompt.new
        if @user.stashes.count == 0
            give_star_divider
            3.times do
                give_space
            end
            prompt.keypress("You haven't stashed any ideas yet!", timeout: 3)
        else
            @user.stashes.each do |stash|
                print_idea_with_generator(stash.idea)
                response = prompt.select("Next to continue, Remove this idea, or quit browsing", %w(Next Remove Quit))
                if response == "Remove"
                    delete_stash(stash)
                    give_space
                    give_space
                end
                break if response == "Quit"
            end
        end
    end

    def delete_stash(stash)
        prompt = TTY::Prompt.new
        give_space
        puts "Removing..."
        stash.destroy
        stash.save
        id = @user.id
        @user = User.find(id)
        give_space
        give_space
        prompt.keypress("All done! This idea has been removed from your stash. 
        Press any key to continue, resumes automatically in 3 seconds ...", timeout: 3)        
    end

##########################################################################################
    #log_out

    def log_out
        system "clear"
        prompt = TTY::Prompt.new
        give_space
        response = prompt.yes?("Log out of Think Tank?")
        if response == false
            landing_page
            log_in_or_create?
        end
        give_space
        puts "                        \\   \\  \\ | || | /  /   /    "
        puts "   Thank you for using    T H I N K   T A N K       "
        puts "                        /   /  / | || | \\  \\   \\    "
        give_space
        give_space
        give_star_divider
        give_star_divider
        give_space
        exit!
    end


#########################################################################################
    #printing methods

    def give_space
        puts "                "
    end

    def give_star_divider
        puts "*" *55
    end

    def print_idea_with_generator(idea)
        give_star_divider
        give_space      
        puts idea.title
        give_space
        puts idea.post
        give_space
        puts "Post generated by #{idea.user.username}."
        puts "Category: #{idea.category}"
        3.times do
            give_space
        end
        give_star_divider
    end

    def print_idea_without_generator(idea)
        prompt = TTY::Prompt.new
        give_star_divider
        give_space
        puts idea.title
        give_space
        puts idea.post
        give_space
        puts "Category: #{idea.category}"
        3.times do
            give_space
        end
        give_star_divider
    end

end