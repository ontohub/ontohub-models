require 'faker'
FactoryGirl.define do
  to_create { |instance| instance.save }
end
