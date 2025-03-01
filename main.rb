require 'sequel'
require 'sinatra'
require "sinatra/json"
require 'pry'
require './db_init.rb'
require './services/operation/operation_request.rb'
require './services/submit/submit_request.rb'

post '/operation' do
  req = request.body.read
  data = JSON.parse(req)

  result = OperationRequest.call(data)

  json(status: "success", data: result)
end

post '/submit' do
  req = request.body.read
  data = JSON.parse(req)

  result = SubmitRequest.call(data)

  json(status: "success", data: result)
end


