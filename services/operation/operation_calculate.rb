require './services/operation/position_property.rb'
require './services/operation/calculate_position'
require './services/operation/common_info'

class OperationCalculate
  def self.call(data)
    user_id = data.dig("user_id")
    products_list = data.dig("positions")

    positions = products_list.each_with_object([]) do | pos, list |
      list << PositionProperty.call(pos)
    end

    user = TEMPLATE.join(USER.where(id: user_id), template_id: :id).to_a.first

    positions = positions.each_with_object([]) do | pos, list |
      list << CalculatePosition.call(user, pos)
    end

    CommonInfo.call(user, positions)
  end
end