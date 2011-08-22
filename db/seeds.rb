# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Category.create [ { :name => 'RYTP' }, { :name => 'RYTPMV' } ] unless Category.any?

Role::LIST.each_pair do |name, mask|
  Role.create :mask => mask, :name => name
end
