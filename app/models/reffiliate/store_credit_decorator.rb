# frozen_string_literal: true

module Reffiliate
  module StoreCreditDecorator
    Spree::StoreCredit::REFERRAL_STORE_CREDIT_CATEGORY = 'Referral Credit'

    def self.prepended(base)
      base.has_one :referred_record
    end

    private

    def referral?
      category.try(:name) == Spree::StoreCredit::REFERRAL_STORE_CREDIT_CATEGORY
    end

    def send_credit_reward_information
      Spree::ReferralMailer.credits_awarded(user, amount.to_f).deliver_later
    end
  end
end

if Spree::StoreCredit.included_modules.exclude?(Reffiliate::StoreCreditDecorator)
  Spree::StoreCredit.prepend Reffiliate::StoreCreditDecorator
end
