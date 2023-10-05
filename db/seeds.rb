# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
Admin.create(email: "admin@example.com", name: "Admin", gender: 'male', password: "password", password_confirmation: "password") unless Admin.where(email: "admin@example.com").exists?
