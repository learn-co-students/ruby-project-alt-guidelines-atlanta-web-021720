
# prompt = TTY::Prompt.new

class CommandLineInterface

    def greet
        give_space
        puts "               \\   \\  \\ | || | /  /   /    "
        puts "   Welcome to    T H I N K   T A N K       "
        puts "               /   /  / | || | \\  \\   \\    "
        #puts more space and a tagline explaining the platform
    end

    def generator_prompt
        prompt = TTY::Prompt.new
        give_space
        puts "Welcome, Generator #{@user.username}."
        choices = ["Browse all ideas", "View your ideas", "Search ideas for keyword", "Post an idea", "Log out of my account", "Log out of Think Tank"]
        selection = prompt.select("What would you like to do today?", (choices))
            if selection == choices[0]
                direct = generator_browse
            elsif selection == choices[1]
                direct = view_own_ideas
            elsif selection == choices[2]
                direct = search_ideas_by_keyword
            elsif selection == choices[3]
                direct = post_idea
            elsif selection == choices[4]
                direct = "user logged out"
            elsif selection == choices[5]
                direct = log_out
            end
        give_space
        direct
        #stretch: type "help" at any time for more info
    end

    def implementer_prompt
        prompt = TTY::Prompt.new
        give_space
        puts "Welcome, Implementer #{@user.username}."
        choices = ["Browse all ideas", "View your stashed ideas", "Search ideas for keyword", "Log out of my account", "Log out of Think Tank"]
        selection = prompt.select("What would you like to do today?", (choices))
            if selection == choices[0]
                direct = implementer_browse
            elsif selection == choices[1]
                direct = view_stashes
            elsif selection == choices[2]
                direct = search_ideas_by_keyword
            elsif selection == choices[3]
                direct = "user logged out"
            elsif selection == choices[4]
                direct = log_out
            end
        direct
        #What would you like to do? type "help" at any time for more info
        #need implementer to be able to delete stashes
        #need implementer to be able to stash from keyword search
    end

    def create_generator_account
        prompt = TTY::Prompt.new
        give_space
        puts "Okay! We can make a Generator account for you."
        username = prompt.ask("Create a username:") do |q|
            q.modify :trim
        end
        email = prompt.ask("What is your email address?") do |q|
            q.modify :trim
        end
        @user = Generator.create(username: username, email: email)
    end

    def create_implementer_account
        prompt = TTY::Prompt.new
        give_space
        puts "Okay! We can make an Implementer account for you."
        username = prompt.ask("Create a username:") do |q|
            q.modify :trim
        end
        email = prompt.ask("What is your email address?") do |q|
            q.modify :trim
        end
        @user = Implementer.create(username: username, email: email)
    end

    def log_in_or_create?
        prompt = TTY::Prompt.new
        give_space
        user_type = prompt.select("Log in or create new user?", (["Log in", "Create new"]))
        if user_type == "Create new"
            give_space
            puts "Here at think tank, we have two different kinds of users."
            puts "A Generator is someone who creates ideas and posts them to share with others."
            puts "An Implementer is someone looking for ideas to build or produce."
            create_response = prompt.select("What would you like to do now?", (["Create Generator Account - I have ideas", "Create Implementer Account - I need ideas", "I already have an account", "Nevermind, I'm done with Think Tank"]))
            if create_response == "Create Generator Account - I have ideas"
                @user = create_generator_account
            elsif create_response == "Create Implementer Account - I need ideas"
                @user = create_implementer_account
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
    end


    def login
        prompt = TTY::Prompt.new
        give_space
        user_type = prompt.select("Are you a generator or an implementer?", %w(Generator Implementer)) 
        if user_type == "Generator"
            @user = nil
            while @user == nil do
                username_response = prompt.ask("Enter your username (case-sensitive):")
                @user = Generator.find_by(username: username_response) do |q|
                    q.modify :trim 
                end
                break if @user
                retry_response = prompt.yes?("Invalid Generator username. Try again?") do |q|
                    q.suffix 'Yup/nope'
                end
                break if retry_response == false
            end
        else
            @user = nil
            while @user == nil do
                username_response = prompt.ask("Enter your username (case-sensitive):")
                @user = Implementer.find_by(username: username_response) do |q|
                    q.modify :trim 
                end
                break if @user
                retry_response = prompt.yes?("Invalid Implementer username. Try again?") do |q|
                    q.suffix 'Yup/nope'
                end
                break if retry_response == false
            end
        end
    end

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
        puts "Post generated by #{idea.generator.username}."
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
        3.times do
            give_space
        end
        give_star_divider
    end



    def generator_browse
        prompt = TTY::Prompt.new
        Idea.all.each do |idea|
            print_idea_with_generator(idea)
            response = prompt.yes?("Enter 'n' to continue, 'q' to quit browsing") do |q|
                    q.suffix 'n/q'
            end
            break if response == false
        end
    end

    def implementer_browse
        prompt = TTY::Prompt.new
        Idea.all.each do |idea|
            print_idea_with_generator(idea)
            response = prompt.select("View next idea, Stash this idea, or quit browsing.", %w(Next Stash Quit))
            if response == "Stash"
                stash_idea(idea)
            end
            break if response == "Quit"
        end
    end

    def view_own_ideas
        prompt = TTY::Prompt.new
        if @user.ideas.count == 0
            give_star_divider
            3.times do 
                give_space 
            end
            puts "You haven't shared any ideas yet!"
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
        prompt = TTY::Prompt.new
        give_star_divider
        give_space
        title = prompt.ask("Please enter the updated idea name", default: idea.title)
        give_space
        post = prompt.multiline("Please enter the updated idea description", default: idea.post)
        give_space
        puts "saving..."
        idea.title = title
        idea.post = post
        idea.save
        give_space
        puts "Edits saved!"
    end

    def search_ideas_by_keyword
        prompt = TTY::Prompt.new
        give_star_divider
        give_space
        response = prompt.ask("Enter the word you would like to search by:")
        lc_response = response.downcase
        give_space
        puts "Preparing your results..."
        #stretch: allow user to search by entering mutiple words
        # response_array = %w(response)
        # keyword_ideas = Idea.all.select do |idea|
        #     idea.title.downcase.include? (response_array.each { |string| string.downcase })
        keyword_ideas = []
        Idea.find_each do |idea|
            if idea.title.downcase.include? lc_response
                keyword_ideas << idea
            end
        end
        if keyword_ideas.count == 0
            puts "No ideas found with #{response} in the title."
        else
            keyword_ideas.each do |idea|
                print_idea_with_generator(idea)
                response = prompt.select("Next to continue, or quit browsing", %w(Next Quit))
                break if response == "Quit"
            end
        end
    end

    def post_idea
        prompt = TTY::Prompt.new
        give_star_divider
        give_space
        confirmation = nil
        title = prompt.ask("Please enter a name for your idea:", required: true)
        give_space
        post = prompt.multiline("Great! Now describe your idea.", required: true)
        give_space
        give_star_divider
        give_space
        confirmation = prompt.yes?("Idea title: #{title},\n\nIdea: #{post.join} \n\nDoes this look right?", required: true)
        if confirmation == false
            give_space
            title = prompt.ask("Please edit your idea name", required: true, value: title)
            give_space
            post = prompt.multiline("Great! Now edit your idea, or press enter .", required: true, value: post)
            #why doesn't the value prepopulate for the multiline prompt?
            give_space
        end
        give_space
        puts "saving..."
        idea = Idea.create(title: title, post: post.join, generator_id: user.id)
        give_space
        prompt.keypress("Thanks, Generator #{user.username}! What an awesome idea. \nIf you decide to edit your idea, you may do so from the options below. \n\nPress any key to continue, resumes automatically in 3 seconds ...", timeout: 3)
    end

    def stash_idea(idea)
        #during browse or find, if user.class == implementer, provide "press S to stash this idea"
        prompt = TTY::Prompt.new
        give_space
        puts "stashing..."
        Stash.create(implementer_id: @user.id, idea_id: idea.id)
        give_star_divider
        give_space
        give_space
        prompt.keypress("Success! Kudos for stashing a great idea. 
        Press any key to continue, resumes automatically in 3 seconds ...", timeout: 3)
        give_space
    end

    def view_stashes
        prompt = TTY::Prompt.new
        #Issue: stashes do not refresh if added or deleted unless a user logs out.
        @user.stashes.each do |stash|
            print_idea_with_generator(stash.idea)
            response = prompt.select("Next to continue, Remove this idea, or quit browsing", %w(Next Remove Quit))
            break if response == "Quit"
            if response == "Remove"
                delete_stash(stash)
                give_space
                give_space
                puts "Please log in again to refresh stashes."
                give_space
                direct = "user logged out"
                return
            end
        end
    end

    def delete_stash(stash)
        prompt = TTY::Prompt.new
        give_space
        puts "Removing..."
        stash.destroy
        prompt.keypress("All done! This idea has been removed from your stash. 
        Press any key to continue, resumes automatically in 3 seconds ...", timeout: 3)
    end

    def log_out
        prompt = TTY::Prompt.new
        response = prompt.yes?("Log out of Think Tank?")
        if response == false
            return
        end
        give_space
        puts "                        \\   \\  \\ | || | /  /   /    "
        puts "   Thank you for using    T H I N K   T A N K       "
        puts "                        /   /  / | || | \\  \\   \\    "
        give_space
        give_star_divider
        exit!
    end

    def run_gen_or_imp_prompts
        if @user.class == Generator
            direct = nil
            until direct == "user logged out" do
                direct = generator_prompt
            end
        elsif @user.class == Implementer
            direct = nil
            until direct == "user logged out" do
                direct = implementer_prompt
            end
        end
    end

    def run_program
        prompt = TTY::Prompt.new
        greet
        give_space
        give_space
        loop do
            #reword the landing page prompt
            landing_page_response = prompt.select("Log in or exit Think Tank", (["Log in", "Exit"]))
            if landing_page_response == "Exit"
                log_out
            end
            log_in_or_create?
            run_gen_or_imp_prompts
        end
    end

end