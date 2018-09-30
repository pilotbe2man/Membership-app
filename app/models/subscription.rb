# == Schema Information
#
# Table name: subscriptions
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  plan_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  terms            :boolean          default("false")
#  month            :integer
#  discount_code_id :integer
#  transaction_id   :integer
#  payment_mode_id  :integer
#

class Subscription < ActiveRecord::Base
    belongs_to :plan
    belongs_to :user    

    belongs_to :discount_code
    belongs_to :payment_mode

    #validates :user_id, :plan_id,                       presence: true
    #validates :user_id,                                 uniqueness: true
    validates :terms,                                   inclusion: { :in => [true], message: 'Please confirm your acceptance of our terms and conditions to complete your subscription upgrade.' }

    
    attr_accessor :stripe_card_token

    # => Processes payment with stripe, assigns stripe customer token from return object and assigns discount code relation if one is present
    #
    def save_with_payment discount_code
        if valid?
            customer = Stripe::Customer.create(description: user.name, email: user.email, plan: plan.name.parameterize.underscore, card: stripe_card_token, coupon: discount_code.try(:code))
            user.update_column(:stripe_customer_token, customer.id)
            user.create_discount_code_user(discount_code_id: discount_code.id) unless discount_code.nil?
            save!
        end
    rescue Stripe::InvalidRequestError => e
        logger.error "Stripe error while creating customer: #{e.message}"
        errors.add :base, "There was a problem with your credit card."
        false
    end
end
