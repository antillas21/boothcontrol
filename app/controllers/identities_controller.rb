class IdentitiesController < ApplicationController
  def index
    require 'pp'

    @hash_schema ||= request.env['omniauth.auth']
    @hash_schema = pp @hash_schema
  end

  def create
    require 'pp'
    omniauth = request.env['omniauth.auth']

    @hash_schema = pp omniauth
  end
end
