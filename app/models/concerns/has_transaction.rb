module HasTransaction
    extend ActiveSupport::Concern

    included do
        has_many :transactions

        def total_deposit_amount
            transactions.where(deposit: true).sum(:amount)
        end

        def paid_plan_type
            ret_value = 0
        	ret_value = transactions.maximum(:plan_type)
            return (ret_value) ? ret_value : 0
        end
    end
end