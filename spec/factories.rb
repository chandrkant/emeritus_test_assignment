# frozen_string_literal: true

require "faker"
FactoryBot.define do
  FactoryBot.use_parent_strategy = false
  factory :user do
    name { "Solanki" }
    gender { "Male" }
    email { "#{Faker::Name.unique.first_name}@gmail.com" }
    password { "password" }
    type { "Admin" }
  end

  factory :school_admin do
    name { Faker::Name.unique.name }
    gender { "Male" }
    email { "#{Faker::Name.unique.first_name}@gmail.com" }
    password { "password" }
    type { "SchoolAdmin" }
  end

  factory :course do
    name { Faker::ProgrammingLanguage.name }
    code { Faker::Code.nric }
    duration { 30 }
  end

  factory :school do
    name { Faker::Name.name }
    code { Faker::Code.nric }
    city { "New Delhi" }
    country { "India" }
    school_admin do
      association(
        :school_admin,
        name: Faker::Name.unique.name,
        type: SchoolAdmin,
        gender: "Male",
        email: "#{Faker::Name.unique.first_name}@gmail.com",
        password: "password"
      )
    end
  end

  factory :batch do
    name { Faker::Name.name }
    start_date { Date.today }
    end_date { Date.today + 30 }
    association :course
    association :school
  end

  factory :enrollment do
    status { "approved" }
    student do
      association(
        :user,
        name: Faker::Name.unique.name,
        type: "SchoolAdmin",
        gender: "Male",
        email: "#{Faker::Name.unique.first_name}@gmail.com",
        password: "password"
      )
    end
    batch do
      association(
        :batch,
        name: Faker::Name.name,
        start_date: Date.today,
        end_date: Date.today + 30
      )
    end
  end

  factory :student do
    name { "Solanki" }
    gender { "Male" }
    email { "#{Faker::Name.unique.first_name}@gmail.com" }
    password { "password" }
    type { "Student" }
  end
  factory :student1 do
    name { "Raman" }
    gender { "Male" }
    email { "#{Faker::Name.unique.first_name}@gmail.com" }
    password { "password" }
    type { "Student" }
  end
  factory :student2 do
    name { "Chandrakant" }
    gender { "Male" }
    email { "#{Faker::Name.unique.first_name}@gmail.com" }
    password { "password" }
    type { "Student" }
  end
end
