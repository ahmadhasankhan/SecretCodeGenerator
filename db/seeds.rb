# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

secret_code = SecretCode.create(code: 'ADN123')
role = Role.create(name: 'admin')
user = User.new(email: 'admin@exmple.com', password: 'admin@123', password_confirmation: 'admin@123')
user.roles << role
user.secret_code = secret_code
user.save!