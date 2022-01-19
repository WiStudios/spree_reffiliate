# frozen_string_literal: true

module Reffiliate
  module OrderDecorator
    def self.prepended(base)
      base.include Spree::TransactionRegistrable

      base.has_many :transactions, as: :commissionable, class_name: 'Spree::CommissionTransaction',
                    dependent: :restrict_with_error
      base.belongs_to :affiliate, class_name: 'Spree::Affiliate'

      # TODO: Manually configure this transition in checkout.rb
      # base.state_machine.after_transition to: :complete, do: :create_commission_transaction
    end

    private

    def create_commission_transaction
      register_commission_transaction(affiliate) if affiliate.present?
    end
  end
end

if Spree::Order.included_modules.exclude?(Reffiliate::OrderDecorator)
  Spree::Order.prepend Reffiliate::OrderDecorator
end
