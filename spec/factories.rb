Factory.define :user do |user|
  user.handle                "Chris Humphreys"
  user.email                 "chris.h@mail.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.skip_session_maintenance true
end

Factory.define :party do |party|
  party.name                 { Factory.next(:name) }
  party.three_letter         "Ind"
  party.one_letter           "I"
end

Factory.define :perp do |perp|
  perp.first_name            "Example"
  perp.last_name             "Perp"
  perp.association :party
end

Factory.sequence :last_name do |n|
  "Perp #{n}"
end

Factory.sequence :name do |n|
  "Party #{n}"
end

Factory.define :statement do |statement|
  statement.content          "Foo bar"
  statement.date             "2001-01-01"
  statement.context          "Context for the statement."
  statement.why_hypocritical "Reasons why the statement is hypocritical"
  statement.why_hyperbolical "Reasons why the statement is hyperbolical"
  statement.association :perp
end
