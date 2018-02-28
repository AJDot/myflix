class ChargeSuccess
  attr_reader :charge

  def initialize(options={})
    @charge = options[:event].data.object
  end

  def process
    user = User.find_by customer_token: charge.customer
    Payment.create(user: user, amount: charge.amount, reference_id: charge.id)
  end
end
