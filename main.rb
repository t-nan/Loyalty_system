require 'sequel'
require 'sinatra'
require "sinatra/json"
require 'pry'
require './db_init.rb'
require './services/operation/operation_calculate.rb'
require './services/submit/confirm_operation.rb'

post '/operation' do
  req = request.body.read
  data = JSON.parse(req)

  result = OperationCalculate.call(data)

  json(status: "ok", data: result)
end

post '/submit' do
  req = request.body.read
  data = JSON.parse(req)

  result = ConfirmOperation.call(data)

  json(status: "ok", data: result)
end


