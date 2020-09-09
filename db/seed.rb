Spree::CommissionRule.find_or_create_by(name: Spree::CommissionRule::USER_REGISTRATION, fixed_commission: true)
Spree::CommissionRule.find_or_create_by(name: Spree::CommissionRule::ORDER_PLACEMENT, fixed_commission: false)
Spree::CommissionRule.find_or_create_by(name: Spree::CommissionRule::ORDER_PLACEMENT_WITH_VENDOR, fixed_commission: false)
