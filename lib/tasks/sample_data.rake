require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:handle                => "Charlie Humphreys", 
                         :email                 => "charlie@humphreys.com", 
                         :password              => "poochie", 
                         :password_confirmation => "poochie")
    admin.toggle!(:admin)
    
    4.times do
      User.create!(:handle                => Faker::Name.first_name, 
                   :email                 => Faker::Internet.email, 
                   :password              => "foobar", 
                   :password_confirmation => "foobar")
    end
    
    Party.create!(:name => "Republican",  :three_letter => "Rep", :one_letter => "R")
    Party.create!(:name => "Democrat",    :three_letter => "Dem", :one_letter => "D")
    Party.create!(:name => "Independent", :three_letter => "Ind", :one_letter => "I")
    
    @perps = Sunlight::Legislator.all_where(:in_office => "1")
    @perps.each do |p|
      party = Party.where(:one_letter => p.party).first
      unless party.nil?
        perp = party.perps.create!(:first_name  => p.firstname, 
                                   :last_name   => p.lastname, 
                                   :middle_name => p.middlename, 
                                   :name_suffix => p.name_suffix, 
                                   :bioguide_id => p.bioguide_id)
        office = perp.offices.create!(:title => p.title, 
                                      :state => p.state, 
                                      :start_date => "2010-01-01")
        office.party_id = perp.party_id
        office.save!
      end
    end
    
    Perp.all.each do |perp|
      (rand * 10).ceil.times do
        perp.statements.create!(:content => Faker::Lorem.sentences(2).join(" ").slice!(0, 139), 
                                :date => (rand * 1000).days.ago, 
                                :context => Faker::Lorem.sentences(4).join(" ").slice!(0, 249))
      end
    end
    
    Statement.find_top_recent_statements.each do |statement|
      base_1 = (rand * 3).to_i * 33
      base_2 = (rand * 3).to_i * 33
      User.all.each do |user|
        @rating = statement.hypocrisy_ratings.build(:rating => base_1 + (rand * 33).to_i)
        @rating.user = user
        @rating.save!
        
        @rating = statement.hyperbole_ratings.build(:rating => base_2 + (rand * 33).to_i)
        @rating.user = user
        @rating.save!
      end
    end
  end
end
