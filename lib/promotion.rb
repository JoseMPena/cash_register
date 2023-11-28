# frozen_string_literal: true

# Creates promotion objects whose rules will be applied to a checkout
class Promotion
  attr_reader :promotable_products

  def initialize(promotable: [])
    @promotable_products = promotable
  end

  def apply(_checkout)
    raise NotImplementedError, 'Should be implemented by a subclass'
  end

  def applicable?(entity)
    if entity.respond_to?(:code)
      promotable_products.include?(entity.code)
    elsif entity.respond_to?(:line_items)
      entity.line_items.any? { |li| applicable?(li) }
    else
      false
    end
  end

  def applicable_line_items(checkout)
    checkout.line_items.select { |li| applicable?(li) }
  end
end
