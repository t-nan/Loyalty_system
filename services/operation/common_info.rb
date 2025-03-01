class CommonInfo
  class << self
    def call(user, positions)

      discount = 0.0
      cashback = 0.0
      base_sum = 0.0
      check_sum = 0.0
      writable_off = 0.0

      positions.each do |pos|
        discount += pos.dig(:total_discount)
        cashback += pos.dig(:total_cashback)
        base_sum += pos.dig(:base_sum)
        check_sum += pos.dig(:cost)

        writable_off += pos.dig(:cost) unless pos.dig(:discount_type).eql?("noloyalty")
      end

      discount_percent = (discount/base_sum * 100).round(1)
      cashback_percent = (cashback/check_sum * 100).round(1)

      available_write_off = user.dig(:bonus) >= writable_off ? writable_off : user.dig(:bonus)

      operation = OPERATION.insert(
        user_id: user.dig(:id),
        cashback: cashback,
        cashback_percent: cashback_percent,
        allowed_write_off: available_write_off,
        discount: discount,
        discount_percent: discount_percent,
        check_summ: check_sum
      )

      if operation
        {
          user_name: user.dig(:name),
          operation_id: operation,
          check_sum: check_sum,
          bonus_info: {
            user_bonuses: user.dig(:bonus).to_f,
            available_write_off: available_write_off,
            cashback_sum: cashback,
            cashback_sum_percent: cashback_percent
          },
          discount_info: {
            discount_sum: discount,
            discount_sum_percent: discount_percent
          },
          positions: positions.map{|e| e.except(:total_cashback, :base_sum)}
        }
      end
    end
  end
end