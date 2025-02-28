require './services/product_property.rb'
require './services/calculate_positions'

class OperationRequest

  def self.call(data)
    user_id = data.dig("user_id")
    products_list = data.dig("positions")

    positions = products_list.each_with_object([]) do | pos, list |
      list << ProductProperty.call(pos)
    end

    user = TEMPLATE.join(USER.where(id: user_id), template_id: :id).to_a.first

    result = positions.each_with_object([]) do | pos, list |
      list << CalculatePositions.call(user, pos)
    end

    x = CommonInfo.call(user, result)
    #result
    #binding.pry
  end

  # def calculate_products()
  #
  # end
end