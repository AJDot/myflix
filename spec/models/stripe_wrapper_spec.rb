require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => "4242424242424242",
        :exp_month => 2,
        :exp_year => 2019,
        :cvc => "314"
      },
    ).id
  end

  let(:declined_token) do
    Stripe::Token.create(
      :card => {
        :number => "4000000000000002",
        :exp_month => 2,
        :exp_year => 2019,
        :cvc => "314"
      },
    ).id
  end

  describe StripeWrapper::Charge do
    describe "create", :vcr do
      it "makes a successful charge" do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => valid_token,
          :description => 'a valid charge'
        )

        expect(response).to be_successful
      end

      it "makes a card declined charge" do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => declined_token,
          :description => 'an invalid charge'
        )

        expect(response).not_to be_successful
      end

      it "return the error message for declined charges" do
        response = StripeWrapper::Charge.create(
          :amount => 999,
          :source => declined_token,
          :description => 'an invalid charge'
        )

        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      it "creates a customer with a valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )
        expect(response).to be_successful
      end

      it "does not create a customer with a declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: declined_token
        )
        expect(response).not_to be_successful
      end

      it "returns the error message for declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: declined_token
        )
        expect(response.error_message).to eq("Your card was declined.")
      end

      it "returns the customer token for a valid card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )
        expect(response.customer_token).to be_present
      end
    end
  end

  describe StripeWrapper::Subscription do
    describe ".create" do
      it "creates a subscription with a valid customer", :vcr do
        alice = Fabricate(:user)
        StripeWrapper::Customer.create(
          user: alice,
          source: valid_token
        )
        response = StripeWrapper::Subscription.create(
          customer: alice.customer_token,
          plan: 'base'
        )

        expect(response).to be_successful
      end

      it "does not create a subscription with an invalid customer", :vcr do
        response = StripeWrapper::Subscription.create(
          customer: "not_a_customer_id",
          plan: 'base'
        )
        expect(response).not_to be_successful
      end
    end
  end
end
