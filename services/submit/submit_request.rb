require './services/operation/product_property.rb'
require './services/operation/calculate_positions'
require './services/operation/common_info'

class SubmitnRequest
  def self.call(data)
    user_id = data.dig("user_id")
    products_list = data.dig("positions")

    positions = products_list.each_with_object([]) do | pos, list |
      list << ProductProperty.call(pos)
    end

    user = TEMPLATE.join(USER.where(id: user_id), template_id: :id).to_a.first

    positions = positions.each_with_object([]) do | pos, list |
      list << CalculatePositions.call(user, pos)
    end

    CommonInfo.call(user, positions)
  end
end