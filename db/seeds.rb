# coding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

Category.create [ { :name => 'RYTP' }, { :name => 'RYTPMV' } ] unless Category.any?

Role::LIST.each_pair do |name, mask|
  Role.find_or_create_by_mask_and_name :mask => mask, :name => name
end

User.new(:name => 'Опасный поцык', :profile_url => 'http://rytp.ru/profile/999999').tap do |u|
  u.id = 999999

  nonamed_poops_count = Poop.unscoped.where(:user_id => nil).count
  Poop.update_all :user_id => nil, :user_id => 999999

  u.poops_count = nonamed_poops_count
  u.save
end unless User.exists?(999999)
