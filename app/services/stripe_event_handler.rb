module StripeEventHandler

  def self.process(options={})
    event = options[:event]

    if event.type == 'charge.succeeded'
      ChargeSuccess.new(event: event).process
    elsif event.type == 'charge.failed'
      ChargeFail.new(event: event).process
    end
  end

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

  class ChargeFail
    attr_reader :charge

    def initialize(options={})
      @charge = options[:event].data.object
    end

    def process
      user = User.find_by customer_token: charge.customer
      user.deactivate!
    end
  end
end
