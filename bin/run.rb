require_relative '../config/environment'
require "tty-prompt"
require 'colorize'


####Allows a user to log-in to an account (Works!)
def login
    2.times do 
    puts ""
    end 
    puts "     `                        `            
    --sN+                      +Ns--         
 -/:NNsN+                      +NsNN:/-      
 oNsNNsN+                      +NsNNsNo      
.ooNsNNsNooo++oooooooooooooo+ooooNsNNsNo+.    
`:oNsNNsN+::-:::::::::::::::::::+NsNNsNo-`    
 oNoNNsN+                      +NsNNoNo      
 .--NmoN+                      +NomN--.      
  ` ``+h/                      /h+`` ` ".red
    puts ""
    puts "         Welcome to OneMoreRep!!"
    puts ""
    prompt = TTY::Prompt.new(active_color: :cyan)
    user_selection = prompt.select("Please Choose One Of The Following?".red, %w(Log-In Create_New_Account Exit))
        if user_selection == 'Create_New_Account'
            puts ""
            user_name = prompt.ask('Please Enter a User Name: ', required: true) do |q|
            q.validate(/\w/)
            q.messages[:valid?] = 'Please Enter a String!'
            end 
            user_pass = prompt.ask('Please Enter a User Password: ', required: true) do |q|
                q.validate(/\w/)
                q.messages[:valid?] = 'Please Enter a String!'
                end 
            name = prompt.ask('Please Enter Your Name: ', required: true) do |q|
                q.validate(/\w/)
                q.messages[:valid?] = 'Please Enter a String!'
                end 
            age = prompt.ask('Please Enter Your Age: ', required: true) do |q|
                q.validate(/\d/)
                q.messages[:valid?] = 'Please Enter an Integer!'
                end 
            weight = prompt.ask('Please Enter Your Weight: ', required: true) do |q|
                q.validate(/\d/)
                q.messages[:valid?] = 'Please Enter an Integer!'
                end 
            height = prompt.ask('Please Enter Your Height: ', required: true) do |q|
                q.validate(/\d/)
                q.messages[:valid?] = 'Please Enter an Integer!'
                end 
            @user = User.find_or_create_by(user_name: user_name, user_password: user_pass, name: name, age: age, weight: weight, height: height)
            puts ""
            puts "Congrats Your New Account is Ready. Please log-in with credentials.".blue
            puts "UserName:  #{@user.user_name}"
            puts "Password:  #{@user.user_password}"
            login
        elsif user_selection == 'Log-In'
            puts ""
            user_name = prompt.ask('Please Enter your User Name: ', required: true)  do |q|
                q.validate(/\w/)
                q.messages[:valid?] = 'Please Enter a String!'
                end 
            user_pass = prompt.mask('Please Enter your User Password: ', required: true)  do |q|
                q.validate(/\w/)
                q.messages[:valid?] = 'Please Enter a String!'
                end 
            # begin
            @user = User.find_by!(user_name: user_name)
            if user_pass == @user.user_password
                userMenu
            else 
                3.times do 
                    puts ""
                end
               puts  "Please enter the correct password!"
               login
            end 
            # rescue 
            #     3.times do 
            #         puts ""
            #     end
            #     puts "User not found!!Please try again"
            #     login
            # end 
        elsif user_selection == 'Exit'
            puts""
            puts "Don't Leave yet! Come Back and Get Your Swole On!"
            puts ""
            exit!
    end
end 

####Displays Menu options to Users(Works!)
def userMenu
    3.times do 
        puts ""
        end 
    puts "             
                    so++//:-.             
                 /s:o/o/+o+oooo:        
                `d-y/o/o::/-.--m/       
                `ydd/h:y-smoo+-yh       
                 -sdhsyy+ydos-.:N.      
                        .M//:..-yo      
                        :N//:...+m      
         -oyhhhhhy+.   sm+-.....:m/     
      `oy+-......-+hs.dh/-......-sm     
     :h:...........:/mh/--.....--+M+    
    `m/...-.......-//mo:--......:/No    
    .m//::/:/:----///hs//......-o/M-    
    +y:shyo/:////+os+/h//-....-:sNh     
    /d--:/shhhhhhs/::::::-...://sM.     
     yh/::::::---....--....---:/yo      
      /mho///::::/+ossyyyysssyhhs`      
       `/hNmhyysyydhys+:.--::-.        
           .-/+/:-`                     ".cyan
           puts ""
    puts "            Welcome #{@user.name}!!"
    puts ""
    prompt = TTY::Prompt.new(active_color: :bright_red)
    user_selection = prompt.select("What Would You Like To Do?".cyan, %w(Update_Info Start_New_Workout View_Past_Workouts Top_Performers Health_is_Wealth Delete_Account Log-Out))
    if user_selection == 'Log-Out'
        puts ""
        puts "               ***********============".red
        puts "               ***********============".red
        puts "               ***********============".red  
        puts "               =======================".red
        puts "               =======================".red
        puts "               =======================".red
        puts "                      MERICA!!        "
        puts "                  Come Back Soon".blue
        puts ""
        exit!
    elsif user_selection == 'Start_New_Workout'
        addWorkout
    elsif user_selection == 'Update_Info'
        updateInfo
    elsif user_selection == 'View_Past_Workouts'
        displayWorkout 
    elsif user_selection == 'Top_Performers'
        topPerformers
    elsif user_selection == 'Health_is_Wealth'
        healthTips
    elsif user_selection == 'Delete_Account'
        deleteAccount
    end
end

####Deletes a user account (Works!)
 def deleteAccount 
    prompt = TTY::Prompt.new(active_color: :bright_red)
    user_selection = prompt.select('Are you sure you want to delete your account!?!?'.red, %w(Yes,_sadly_I_want_to.. No,_I_changed_my_mind!))
    if user_selection == 'Yes,_sadly_I_want_to..'
        User.delete(@user.id)
        puts "#########################".red
        puts "#########################".cyan
        puts "Hate to See You Go #{@user.name}".red 
        puts "#########################".cyan
        puts "#########################".red
    else 
        userMenu
    end
end

####Allows a user to create a workout and log it(Works!)
def addWorkout
    prompt = TTY::Prompt.new(active_color: :cyan)
    puts ""
    user_selection = prompt.select("Which part of the body do you want to focus on?".red, %w(UpperBody LowerBody))
    puts ""
    userWorkoutName = prompt.select("What kind of workout is this?".red, %w(Morning_Workout Afternoon_Workout Evening_Workout))
    selectedWorkouts = Workout.find_each.select { |workout| workout.workout_type == user_selection }
        puts ""
        puts "Starting Workout..."
        puts "First exercise is #{selectedWorkouts[0].name}".red
        workout_weight1 = prompt.ask('Please Enter How Much Weight You Used: '.cyan, required: true)  do |q|
            q.validate(/\d/)
            q.messages[:valid?] = 'Please Enter an Integer!'
            end 
        workout_reps1 = prompt.ask('Please Enter How Many Reps You Completed: '.cyan, required: true) do |q|
            q.validate(/\d/)
            q.messages[:valid?] = 'Please Enter an Integer!'
            end 
        UserWorkout.create(name: userWorkoutName, user_id: @user.id, workout_id: selectedWorkouts[0].id, workout_reps: workout_reps1, workout_weight: workout_weight1, workout_type: selectedWorkouts[0].workout_type, workout_name: selectedWorkouts[0].name, workout_time: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
        puts ""
        puts "Second exercise is #{selectedWorkouts[1].name}".red
        workout_weight2 = prompt.ask('Please Enter How Much Weight You Used: '.cyan, required: true) do |q|
            q.validate(/\d/)
            q.messages[:valid?] = 'Please Enter an Integer!'
            end 
        workout_reps2 = prompt.ask('Please Enter How Many Reps You Completed: '.cyan, required: true) do |q|
            q.validate(/\d/)
            q.messages[:valid?] = 'Please Enter an Integer!'
            end 
        UserWorkout.create(name: userWorkoutName, user_id: @user.id, workout_id: selectedWorkouts[1].id, workout_reps: workout_reps2, workout_weight: workout_weight2, workout_type: selectedWorkouts[1].workout_type, workout_name: selectedWorkouts[1].name, workout_time: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
        puts ""
        puts "Great Job!! Workout is Complete!!".cyan
        puts "You #{selectedWorkouts[0].name}ed #{workout_weight1} #{workout_reps1} times!!".red
        puts "You #{selectedWorkouts[1].name}ed #{workout_weight2} #{workout_reps2} times!!".red
        userMenu   
end


####Selects all UserWorkouts that belong to User(Works!)
def displayWorkout
    puts "All of #{@user.name}'s completed workouts".cyan
    prompt = TTY::Prompt.new(active_color: :cyan)
    selectedWorkouts = UserWorkout.find_each.select { |workout|workout.user_id == @user.id}
    selectedWorkouts.each do |workout| 
        puts "#####################################".cyan
        puts "User: #{@user.name}"
        puts "Workout Time: #{workout.workout_time}"
        puts "Workout Name:  #{workout.name}"
        puts "Workout Type: #{workout.workout_type}"
        puts "Exercise Name:  #{workout.workout_name}"
        puts "Weight: #{workout.workout_weight}"
        puts "Reps: #{workout.workout_reps}"
    end
    puts ""
    puts ""
    user_selection = prompt.select("What Would You Like to Do Now?".red, %w(Start_New_Workout Menu))
    if user_selection == 'Start_New_Workout'
        addWorkout  
    elsif user_selection == 'Menu'
        userMenu
    end 
end

####Updates User Information(Works!)
def updateInfo
    prompt = TTY::Prompt.new(active_color: :cyan)
    user_selection = prompt.select("Please Select What You Would Like to Edit (Select Menu to Go Back)".red, %w(UserName Password Name Age Weight Height Menu))
    if user_selection == 'UserName'
        puts "Current UserName is #{@user.user_name}"
        user_name = prompt.ask('Please Enter a New User Name: ', required: true) do |q|
            q.validate(/\w/)
            q.messages[:valid?] = 'Please Enter a String!'
        end 
        @user.user_name = user_name
        @user.save
        puts "New User Name is #{@user.user_name}"
        updateInfo
    elsif user_selection == 'Password'
        puts "Current Password is #{@user.user_password}"
        user_password = prompt.ask('Please Enter a New Password: ', required: true) do |q|
            q.validate(/\w/)
            q.messages[:valid?] = 'Please Enter a String!'
        end 
        @user.user_password = user_password
        @user.save
        puts "New Password is #{@user.user_password}"
        updateInfo
    elsif user_selection == 'Name'
        puts "Current Name is #{@user.name}"
        name = prompt.ask('Please Enter a New Name: ', required: true) do |q|
            q.validate(/\w/)
            q.messages[:valid?] = 'Please Enter a String!'
        end 
        @user.name = name
        @user.save
        puts "New Name is #{@user.name}"
        updateInfo
    elsif user_selection == 'Age'
        puts "Current Age is #{@user.age}"
        age = prompt.ask('Please Enter a New Age: ', required: true) do |q|
            q.validate(/\d/)
            q.messages[:valid?] = 'Please Enter an Integer!'
        end 
        @user.age = age
        @user.save
        puts "New Age is #{@user.age}"
        updateInfo
    elsif user_selection == 'Weight'
        puts "Current Weight is #{@user.weight}"
        weight = prompt.ask('Please Enter a New Weight: ', required: true) do |q|
            q.validate(/\d/)
            q.messages[:valid?] = 'Please Enter an Integer!'
        end 
        @user.weight = weight
        @user.save
        puts "New Weight is #{@user.weight}"
        updateInfo
    elsif user_selection == 'Height'
        puts "Current Height is #{@user.height}"
        height = prompt.ask('Please Enter a New Height: ', required: true) do |q|
            q.validate(/\d/)
            q.messages[:valid?] = 'Please Enter an Integer!'
        end 
        @user.height = height
        @user.save
        puts "New Height is #{@user.height}"
        updateInfo
    elsif user_selection == 'Menu'
        userMenu
    end 
end


####Displays a leaderboard of the top performers
def topPerformers
    sortedPerformers = {}
    User.all.each do |user|
    workoutAmount = UserWorkout.find_each.select{|workout|workout.user_id == user.id}
    sortedPerformers[user.name] = workoutAmount.length
    end 
    count = 1
    finalHash = sortedPerformers.sort_by {|k, v| -v}
    puts "OneMoreRep's Top Performers"
    puts "User's name and their exercise log amount".red
    puts "##############################################".cyan
    finalHash.each do |key, value|
        puts "#{count}. #{key} #{value}"
        count +=1 
    end
    prompt = TTY::Prompt.new(active_color: :cyan)
    puts ""
    user_selection = prompt.select("Feeling Motivated Or Nah?".red, %w(Start_A_New_Workout_And_Rise_To_The_Top Head_Back_To_Menu))
    if user_selection == 'Start_A_New_Workout_And_Rise_To_The_Top'
        addWorkout  
    elsif user_selection == 'Head_Back_To_Menu'
        userMenu
    end 
end 

####Method to start the application
def run_cli
    login
end

####Displays a randomn Health tip to the user
def healthTips
    prompt = TTY::Prompt.new(active_color: :cyan)
    healthtips = ["Eat a variety of foods.", "Base your diet on plenty of foods rich in carbohydrates.", "Replace saturated with unsaturated fat.",
                "Enjoy plenty of fruits and vegetables.", "Reduce salt and sugar intake.", "Eat regularly, control the portion size.", "Drink plenty of fluids.",
                "Maintain a healthy body weight."]
    puts ""
    puts "A little birdie told me...."
    puts "          #{healthtips.sample}"
    puts ""
    user_selection = prompt.select("Want to Head Back?".red, %w(Go_Back))
    if user_selection == 'Go_Back'
        userMenu
    end
end

####Calls the run_cli method to start the app
run_cli

