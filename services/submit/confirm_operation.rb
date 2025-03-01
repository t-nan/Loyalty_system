class ConfirmOperation
  def self.call(data)
    user_id = data.dig("user", "id")
    operation_id = data.dig("operation_id")
    write_off = data.dig("write_off").to_f

    user = USER.where(id: user_id)
    user_hash = user.to_a.first
    return "Пользователь не найден" unless user_hash
    return "У пользователя недостаточно бонусов" if write_off > user_hash.dig(:bonus).to_f

    operation = OPERATION.where(id: operation_id, user_id: user_id)
    operation_hash = operation.to_a.first
    return "Операция не найдена" unless operation_hash
    return "Недопустимая сумма списания баллов" if write_off > operation_hash.dig(:allowed_write_off).to_f

    begin
      DB.transaction do
        user.update(bonus: user_hash.dig(:bonus) - write_off + operation_hash.dig(:cashback) )
        operation.update( write_off: write_off, done: true )
      end
    rescue
      return "Системная ошибка"
    end

    operation = OPERATION.where(id: operation_id, user_id: user_id).to_a.first
    pay_sum = operation.dig(:check_summ) - operation.dig(:write_off)

    {
      system_message: "success",
      operation_info: {
        user_id: user_id.to_f,
        cashback: operation.dig(:cashback).to_f,
        cashback_percent: operation.dig(:cashback_percent).to_f,
        discount: operation.dig(:discount).to_f,
        discount_percent: operation.dig(:discount_percent).to_f,
        write_off: operation.dig(:write_off).to_f,
        pay_sum: pay_sum.to_f
      }
    }
  end
end