# frozen_string_literal: true

module Reffiliate
  module RoleDecorator
    module ClassMethods
      def affiliate
        find_or_create_by(name: :affiliate)
      end
    end

    def self.prepended(base)
      base.extend(ClassMethods)
    end
  end
end

if Spree::Role.included_modules.exclude?(Reffiliate::RoleDecorator)
  Spree::Role.prepend Reffiliate::RoleDecorator
end
