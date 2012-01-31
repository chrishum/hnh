FactoryGirl.define do

  factory :user do 
    handle                "Chris Humphreys"
    sequence(:email)      {|n| "chris.h.#{n}@mail.com"}
    password              "foobar"
    password_confirmation "foobar"
    skip_session_maintenance true
  end

  factory :party do 
    sequence(:name)    {|n| "Party #{n}"}
    three_letter "Ind"
    one_letter   "I"
  end

  factory :perp do
    first_name            "Example"
    sequence(:last_name) {|n| "Perp #{n}"}
    association :party
  end

  factory :statement do 
    content          "Foo bar"
    date             "2001-01-01"
    context          "Context for the statement."
    why_hypocritical "Reasons why the statement is hypocritical"
    why_hyperbolical "Reasons why the statement is hyperbolical"
    association :perp
  end

  factory :hypocrisy_rating do 
    rating "56"
    type   "HypocrisyRating"
    association :user
    association :statement
  end

  factory :hyperbole_rating do 
    rating "56"
    type   "HyperboleRating"
    association :user
    association :statement
  end
end
