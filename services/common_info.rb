class CommonInfo
  class << self
    def call(user, positions)

      discount_sum = 0
      discount_sum_percent = 0
      cashback_sum = 0
      cashback_sum_percent = 0
      purchase_sum = 0
      writable_off = 0

      positions.each do |pos|
        discount_sum += pos.dig(:total_discount)
        discount_sum_percent += pos.dig(:total_discount_percent)
        cashback_sum += pos.dig(:total_cashback)
        cashback_sum_percent += pos.dig(:total_cashback_percent)
        purchase_sum += pos.dig(:total_sum)

        writable_off += pos.dig(:total_sum) unless pos.dig(:discount_type).eql?("noloyalty")
      end

      available_write_off = user.dig(:bonus) >= writable_off ? writable_off : user.dig(:bonus)

      # operation = OPERATION.insert(
      #   user_id: user.dig(:id),
      #   cashback: total_cashback,
      #   cashback_percent: cashback_info[:value],
      #   allowed_write_off: allowed_write_off,
      #   discount: total_discount,
      #   discount_percent: discount_info[:value],
      #   check_summ: check_sum
      # )

      {
        user_name: user.dig(:name),
        operation_id: 0,
        purchase_sum: purchase_sum,
        bonus_info: {
          user_bonuses: user.dig(:bonus).to_f,
          available_write_off: available_write_off,
          cashback_sum: cashback_sum,
          cashback_sum_percent: cashback_sum_percent
        },
        discount_info: {
          discount_sum: discount_sum,
          discount_sum_percent: discount_sum_percent
        },
        positions: positions
      }
    end
  end
end