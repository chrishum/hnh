require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:name          => "Charlie Humphreys", 
                 :email                 => "charlie@humphreys.com", 
                 :password              => "poochie", 
                 :password_confirmation => "poochie")
    admin.toggle!(:admin)
    
    99.times do |n|
      first_name = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      party      = Faker::Lorem.words(1)
      Perp.create!(:first_name => first_name, 
                   :last_name  => last_name, 
                   :party      => party)
    end
  end
end
      