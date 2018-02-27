module StripeWrapper
  class Charge
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: "usd",
          source: options[:source],
          description: options[:description]
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end

  class Customer
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          email: options[:user].email,
          source: options[:source]
        )
        self.add_stripe_id_to_user(options[:user], response.id)
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end

    private

    def self.add_stripe_id_to_user(user, stripe_id)
      user.stripe_id = stripe_id
      user.save
    end
  end

  class Subscription
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Subscription.create(
          customer: options[:customer],
          items: [{ plan: options[:plan] }]
        )
        new(response: response)
      rescue Stripe::InvalidRequestError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end
end
