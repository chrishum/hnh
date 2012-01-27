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
        perp.statements.create!(:content => Faker::Lorem.sentences(2).join(" "), 
                                :date => (rand * 1000).days.ago, 
                                :context => Faker::Lorem.sentences(4).join(" "))
      end
    end
  end
end
