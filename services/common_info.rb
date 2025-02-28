class CalculatePositions
  def self.call(user, position)
    @user = user
    @position = position
    @full_discount = full_discount

    {
      discount_type: discount_type,
      total_sum: total_sum,
      name: position&.dig(:name),
      total_discount_percent: total_discount_percent,
      total_discount: total_discount,
      total_cashback: total_cashback,
      total_cashback_percent: total_cashback_percent
    }
  end

  class << self
    def full_discount
      @position.dig(:base_sum) * (@position.dig(:discount_percent) + @user.dig(:discount).to_f)/100
    end

    def total_sum
      return @position.dig(:base_sum) if @position.dig(:type).eql?("noloyalty")

      @position.dig(:base_sum) - full_discount
    end

    def total_discount
      @position.dig(:base_sum) - total_sum
    end

    def total_discount_percent
      ((total_discount/@position.dig(:base_sum)) * 100).round(1)
    end

    def discount_type
      product_discount = @position.dig(:discount_percent)
      template_discount =  @user.dig(:discount)

      if product_discount > 0 && template_discount > 0
        "by_product/by_template"
      elsif product_discount > 0
        "by_product"
      elsif template_discount > 0 && @position.dig(:type) != "noloyalty"
        "by_template"
      elsif product_discount.to_i.zero? && template_discount.to_i.zero?
        "no_discount"
      elsif @position.dig(:type).eql?("noloyalty")
        "noloyalty"
      end
    end

    def total_cashback_percent
      return 0.0 if @position.dig(:type).eql?("noloyalty")

      @position.dig(:cashback_percent) + @user.dig(:cashback).to_f
    end

    def total_cashback
      total_sum * (total_cashback_percent/100)
    end
  end
end