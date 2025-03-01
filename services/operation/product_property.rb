class ProductProperty
  def self.call(position)
    base_sum = (position.dig("price") * position.dig("quantity")).to_f

    @product = PRODUCT.where(id: position.dig("id")).first
    discount_percent = self.discount_percent
    #discount = (discount_percent/100) * base_sum
    cashback_percent = self.cashback_percent
    #cashback = (cashback_percent/100) * base_sum

    {
      id: @product&.dig(:id) || position.dig("id"),
      name: @product&.dig(:name) || "no name",
      type: @product&.dig(:type) || "another",
      cashback_percent: cashback_percent,
      #product_cashback: cashback,
      discount_percent: discount_percent,
      #product_discount: discount,
      base_sum: base_sum,
      #total_by_product: base_sum - discount
    }
  end

  private

  def self.discount_percent
    @product&.dig(:type) == ("discount") ? @product.dig(:value).to_f : 0.0
  end

  def self.cashback_percent
    @product&.dig(:type).eql?("increased_cashback") ? @product.dig(:value).to_f : 0.0
  end
end