class PositionProperty
  class << self
    def call(position)
      @product = PRODUCT.where(id: position.dig("id")).first

      base_sum = position.dig("price") * position.dig("quantity").to_f
      discount_percent = self.discount_percent
      cashback_percent = self.cashback_percent

      {
        id: @product&.dig(:id) || position.dig("id"),
        name: @product&.dig(:name) || "no name",
        type: @product&.dig(:type) || "another",
        cashback_percent: cashback_percent,
        discount_percent: discount_percent,
        base_sum: base_sum,
      }
    end

    private

    def discount_percent
      @product&.dig(:type) == ("discount") ? @product.dig(:value).to_f : 0.0
    end

    def cashback_percent
      @product&.dig(:type).eql?("increased_cashback") ? @product.dig(:value).to_f : 0.0
    end
  end
end