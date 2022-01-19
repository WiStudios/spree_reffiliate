# frozen_string_literal: true

module Reffiliate
  module AppConfigurationDecorator
    def self.prepended(base)
      base.preference :admin_affiliates_per_page, :integer, default: 10
      base.preference :admin_commissions_per_page, :integer, default: 10
      base.preference :admin_transactions_per_page, :integer, default: 10
      base.preference :referred_records_per_page, :integer, default: 10
      base.preference :referral_credits, :decimal, default: 0
      base.preference :referrer_benefit_enabled, :boolean, default: false
    end
  end
end

if Spree::AppConfiguration.included_modules.exclude?(Reffiliate::AppConfigurationDecorator)
  Spree::AppConfiguration.prepend Reffiliate::AppConfigurationDecorator
end
