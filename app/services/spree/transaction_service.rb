module Spree
  class TransactionService

    attr_accessor :transaction, :affiliate, :affiliate_commission_rule, :amount, :videoplasty_id, :vendor_commission_rule

    def calculate_commission_amount
      if affiliate_commission_rule.present?
        rate = affiliate_commission_rule.rate
        if affiliate_commission_rule.fixed_commission?
          @amount = rate
        else
          if vendor_commission_rule.present?
            vendor_rate = vendor_commission_rule.rate
            @amount = 0
            transaction.commissionable.line_items.includes(product: :vendor).group_by { |li| li.product.vendor }.each do |vendor, vendor_line_items|
              if vendor.present? and vendor.id != videoplasty_id
                _rate = vendor_rate
              else
                _rate = rate
              end
              # @amount += ((vendor_line_items.pluck(:price).sum + vendor_line_items.pluck(:promo_total).sum) * (_rate)) / 100
              @amount += (vendor_line_items.sum(&:after_credits_value) * _rate) / 100
            end
          else
            @amount = (transaction.commissionable.line_items.sum(&:after_credits_value) * rate) / 100
          end
        end
        @amount.to_f
      end
    end

    private

      def initialize(transaction)
        @transaction = transaction
        @affiliate = transaction.affiliate
        if @transaction.commissionable_type.eql? 'Spree::User'
          @affiliate_commission_rule = affiliate.affiliate_commission_rules.active.user_registration.first
        elsif @transaction.commissionable_type.eql? 'Spree::Order'
          @videoplasty_id = Spree::Vendor.where(name: "VideoPlasty").first&.id
          if @transaction.commissionable.line_items.includes(product: :vendor).where.not('spree_products.vendor_id' => @videoplasty_id).exists?
            @vendor_commission_rule = affiliate.affiliate_commission_rules.active.order_placement_with_vendor.first
          end
          @affiliate_commission_rule = affiliate.affiliate_commission_rules.active.order_placement.first
        end
      end
  end
end
