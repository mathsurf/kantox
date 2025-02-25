class Checkout
  attr_reader :discount_rules, :cart, :product_prices

  def initialize(discount_rules = {}, product_prices = {})
    @discount_rules = discount_rules
    @product_prices = product_prices
    @cart = []
  end

  def scan(product)
    @cart << product
  end

  def total
    item_counts = @cart.tally
    total_amount = 0.0

    item_counts.each do |product, quantity|
      price = product_prices[product] || 0
      total_amount += discount_rules.fetch(product, ->(q, p) { q * p }).call(quantity, price)
    end
    
    total_amount.round(2)
  end
end