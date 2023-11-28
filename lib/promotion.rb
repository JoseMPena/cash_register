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

  def applicable?(_entity)
    raise NotImplementedError, 'Should be implemented by a subclass'
  end
end
