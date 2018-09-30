module HasDiscountCode
    extend ActiveSupport::Concern

    included do
        has_one :discount_code_user
        has_one :discount_code, through: :discount_code_user
    end
end