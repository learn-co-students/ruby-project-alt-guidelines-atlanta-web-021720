#Clears out old seed data 
puts "Clearing seed data.."
    User.destroy_all
    Workout.destroy_all
    UserWorkout.destroy_all 


#Creates Users
puts "Creating users..."
user1 = User.find_or_create_by(user_name: "GC391", user_password: "123", name: "Gene", age: 28, weight: 190, height: 72)
user2 = User.find_or_create_by(user_name: "BMoney69", user_password: "456", name: "Bryan", age: 22, weight: 150, height: 62)
user3 = User.find_or_create_by(user_name: "Spen88", user_password: "abc", name: "Spencer", age: 38, weight: 193, height: 82)
user4 = User.find_or_create_by(user_name: "PayTrey11", user_password: "def", name: "Trey", age: 25, weight: 225, height: 96)

#Creates Workouts
puts "Creating workouts..."
workout1 = Workout.find_or_create_by(name: "Curl", workout_type: "UpperBody", difficulty_rating: 9)
workout2 = Workout.find_or_create_by(name: "Bench Press", workout_type: "UpperBody", difficulty_rating: 3)
workout3 = Workout.find_or_create_by(name: "Leg Press", workout_type: "LowerBody", difficulty_rating: 6)
workout4 = Workout.find_or_create_by(name: "Squat", workout_type: "LowerBody", difficulty_rating: 8)

#Creates User Workouts
puts "Creates user workouts..." 
userWorkout1 = UserWorkout.find_or_create_by(name: "Morning Workout", user_id: user1.id, workout_id: workout1.id, workout_reps: 10, workout_weight: 80, workout_type: workout1.workout_type, workout_name: workout1.name, workout_time: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
userWorkout2 = UserWorkout.find_or_create_by(name: "Afternoon Workout", user_id: user1.id, workout_id: workout2.id, workout_reps: 10, workout_weight: 225, workout_type: workout2.workout_type, workout_name: workout2.name, workout_time: Time.now.strftime("%Y-%m-%d %H:%M:%S"))
#Seed Data Created!