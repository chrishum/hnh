require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:handle          => "Charlie Humphreys", 
                         :email                 => "charlie@humphreys.com", 
                         :password              => "poochie", 
                         :password_confirmation => "poochie")
    admin.toggle!(:admin)
    
    Party.create!(:name => "Republican",  :three_letter => "Rep", :one_letter => "R")
    Party.create!(:name => "Democrat",    :three_letter => "Dem", :one_letter => "D")
    Party.create!(:name => "Independent", :three_letter => "Ind", :one_letter => "I")
    
    30.times do |n|
      first_name = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      party      = Party.find_by_id(1 + Random.rand(3))
      party.perps.create!(:first_name => first_name, 
                   :last_name  => last_name)
    end
    
    Perp.all.each do |perp|
      (rand * 50).ceil.times do
        perp.statements.create!(:content => Faker::Company.catch_phrase, 
                                :date => (rand * 3000).days.ago, 
                                :context => Faker::Lorem.sentences(4).join(" "))
      end
    end
    
    Perp.all.each do |perp|
      @office = perp.offices.create!(:title => "Representative", 
                           :state => Faker::Address.us_state_abbr,  
                           :start_date => "2010-01-01")
      @office.party_id = perp.party_id
      @office.save!
    end
  end
end
