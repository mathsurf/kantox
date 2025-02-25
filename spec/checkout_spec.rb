# RSpec Tests
require 'rspec'
require_relative '../lib/checkout'


# Discount Rules
discount_rules = {
  "GR1" => ->(quantity, price) { (quantity / 2 + quantity % 2) * price },
  "SR1" => ->(quantity, price) { quantity >= 3 ? quantity * (price - 0.50) : quantity * price },
  "CF1" => ->(quantity, price) { quantity >= 3 ? quantity * (price * 2 / 3) : quantity * price }
}

# Product Prices
product_prices = {
  "GR1" => 3.11,
  "SR1" => 5.00,
  "CF1" => 11.23
}

describe Checkout do
  let(:co) { Checkout.new(discount_rules, product_prices) }

  it 'calculates total price correctly for basket GR1,SR1,GR1,GR1,CF1' do
    co.scan("GR1")
    co.scan("SR1")
    co.scan("GR1")
    co.scan("GR1")
    co.scan("CF1")
    expect(co.total).to eq(22.45)
  end

  it 'calculates total price correctly for basket GR1,GR1' do
    co.scan("GR1")
    co.scan("GR1")
    expect(co.total).to eq(3.11)
  end

  it 'calculates total price correctly for basket SR1,SR1,GR1,SR1' do
    co.scan("SR1")
    co.scan("SR1")
    co.scan("GR1")
    co.scan("SR1")
    expect(co.total).to eq(16.61)
  end

  it 'calculates total price correctly for basket GR1,CF1,SR1,CF1,CF1' do
    co.scan("GR1")
    co.scan("CF1")
    co.scan("SR1")
    co.scan("CF1")
    co.scan("CF1")
    expect(co.total).to eq(30.57)
  end
end
