# encoding: utf-8
require 'rubygems'
require 'carrierwave/orm/datamapper'   
require 'dm-core'
require 'dm-validations'
require 'dm-pager'

$:.unshift File.dirname(__FILE__) + '/../lib'

class Mpoint
  
  # Class Configurations ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  include DataMapper::Resource
  
  # Attributes ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  property :id,                 Serial
  property :user_id,             Integer
  property :point,              Integer

  #P- 플러스요소 / M- 마이너스 요소 
  # M01 : MBook 다운로드 
  property :account,            String
  property :info,               String
  property :mbookdncount_id,    Integer
  
  timestamps :at


end

DataMapper.auto_upgrade!