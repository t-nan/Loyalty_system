require 'sequel'
require 'sinatra'
require "sinatra/json"
require 'pry'
require './services/operation_request.rb'
require './db_init.rb'

post '/operation' do
  req = request.body.read
  data = JSON.parse(req)

  OperationRequest.call(data)
  # result = Operation.new(request).products_info.result

  json(data: "Test.test")
end


