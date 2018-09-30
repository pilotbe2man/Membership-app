class Discounter
    attr_reader :price, :discount_code

    def initialize data
        @price              = data[:price]
        @discount_code      = data[:discount_code]
    end

    def price
        if code.nil?
            return @price
        else
            return calculate(@price)
        end
    end

    def code
        @code ||= DiscountCode.find_by_code(@discount_code)
    end

    private

    def invalid_discount_code?
         return code.nil? ? true : false
    end

    def invalid_discount_price_type?
        return code.price_type == price_type ? false : true
    end

    def calculate price
        return price - (price*(code.value/100)) 
    end
end