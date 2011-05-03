# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-pager'

class Category
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource
  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,           Serial
  property :name,         String, :required => true
  property :priority,     Integer, :default => 9999
  property :gubun,        String, :default => "template"
  property :icon_image,   String, :default => "icon_category.png"
  
  property :level,        Integer
  property :parent_id,    Integer
  property :display_fl,   Boolean, :default => true
  timestamps :at

  has n, :subcategories

  # def self.up
  #   if Category.first(:name => '명함') == nil
  #     Category.new(:name=>'명함', :priority=>1).save
  #     Category.new(:name=>'현수막', :priority=>2).save
  #     Category.new(:name=>'봉투', :priority=>3).save  
  #   else 
  #     puts Category.first(:priority => 1).id
  #   end
  # end
end
