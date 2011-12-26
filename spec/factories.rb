Factory.define :user do |user|
  user.name                  "Chris Humphreys"
  user.email                 "chris.h@mail.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :perp do |perp|
  perp.first_name            "Example"
  perp.last_name             "Perp"
  perp.party                 "Independent"
end