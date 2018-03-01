require 'spec_helper'

describe StripeEventHandlerController do
  describe 'POST create' do
    context "charge.succeeded", :vcr do
      let(:event_data) do
        {
          "id" => "evt_1C0WXREB8VdfobgqqYDjFG3g",
          "object" => "event",
          "api_version" => "2018-02-06",
          "created" => 1519830493,
          "data" => {
            "object" => {
              "id" => "ch_1C0WXQEB8VdfobgqEZBzQXe7",
              "object" => "charge",
              "amount" => 999,
              "amount_refunded" => 0,
              "application" => nil,
              "application_fee" => nil,
              "balance_transaction" => "txn_1C0WXREB8VdfobgqGeeASm34",
              "captured" => true,
              "created" => 1519830492,
              "currency" => "usd",
              "customer" => "cus_CPLDOcpgZ0fgQS",
              "description" => nil,
              "destination" => nil,
              "dispute" => nil,
              "failure_code" => nil,
              "failure_message" => nil,
              "fraud_details" => {
              },
              "invoice" => "in_1C0WXQEB8VdfobgqGy2NfNy6",
              "livemode" => false,
              "metadata" => {
              },
              "on_behalf_of" => nil,
              "order" => nil,
              "outcome" => {
                "network_status" => "approved_by_network",
                "reason" => nil,
                "risk_level" => "normal",
                "seller_message" => "Payment complete.",
                "type" => "authorized"
              },
              "paid" => true,
              "receipt_email" => nil,
              "receipt_number" => nil,
              "refunded" => false,
              "refunds" => {
                "object" => "list",
                "data" => [
                ],
                "has_more" => false,
                "total_count" => 0,
                "url" => "/v1/charges/ch_1C0WXQEB8VdfobgqEZBzQXe7/refunds"
              },
              "review" => nil,
              "shipping" => nil,
              "source" => {
                "id" => "card_1C0WXPEB8VdfobgqjCQ7WJsd",
                "object" => "card",
                "address_city" => nil,
                "address_country" => nil,
                "address_line1" => nil,
                "address_line1_check" => nil,
                "address_line2" => nil,
                "address_state" => nil,
                "address_zip" => nil,
                "address_zip_check" => nil,
                "brand" => "Visa",
                "country" => "US",
                "customer" => "cus_CPLDOcpgZ0fgQS",
                "cvc_check" => "pass",
                "dynamic_last4" => nil,
                "exp_month" => 11,
                "exp_year" => 2019,
                "fingerprint" => "pel6e9vrF4SvsbpN",
                "funding" => "credit",
                "last4" => "4242",
                "metadata" => {
                },
                "name" => "alexexample@example.com",
                "tokenization_method" => nil
              },
              "source_transfer" => nil,
              "statement_descriptor" => nil,
              "status" => "succeeded",
              "transfer_group" => nil
            }
          },
          "livemode" => false,
          "pending_webhooks" => 1,
          "request" => {
            "id" => "req_Nds7EN1XnCgsqk",
            "idempotency_key" => nil
          },
          "type" => "charge.succeeded"
        }
      end
      let(:alice) { Fabricate(:user, customer_token: "cus_CPLDOcpgZ0fgQS") }

      before do
        alice
        post :create, event_data
      end

      it "creates a payment with the webhook from stripe for charge succeeded" do
        expect(Payment.count).to eq(1)
      end

      it "create the payment associated with user" do
        expect(Payment.first.user).to eq(alice)
      end

      it "creates the payment with the right amount" do
        expect(Payment.first.amount).to eq(999)
      end

      it "creates the payment with reference_id" do
        expect(Payment.first.reference_id).to eq("ch_1C0WXQEB8VdfobgqEZBzQXe7")
      end
    end

    context 'charge.failed' do
      let(:event_data) do
        {
          "id" => "evt_1C0qrZEB8Vdfobgq0oMJOUSQ",
          "object" => "event",
          "api_version" => "2018-02-06",
          "created" => 1519908621,
          "data" => {
            "object" => {
              "id" => "ch_1C0qrZEB8Vdfobgq37imr69C",
              "object" => "charge",
              "amount" => 999,
              "amount_refunded" => 0,
              "application" => nil,
              "application_fee" => nil,
              "balance_transaction" => nil,
              "captured" => false,
              "created" => 1519908621,
              "currency" => "usd",
              "customer" => "cus_CPR8WVXKrhhQE2",
              "description" => "failed payment",
              "destination" => nil,
              "dispute" => nil,
              "failure_code" => "card_declined",
              "failure_message" => "Your card was declined.",
              "fraud_details" => {
              },
              "invoice" => nil,
              "livemode" => false,
              "metadata" => {
              },
              "on_behalf_of" => nil,
              "order" => nil,
              "outcome" => {
                "network_status" => "declined_by_network",
                "reason" => "generic_decline",
                "risk_level" => "normal",
                "seller_message" => "The bank did not return any further details with this decline.",
                "type" => "issuer_declined"
              },
              "paid" => false,
              "receipt_email" => nil,
              "receipt_number" => nil,
              "refunded" => false,
              "refunds" => {
                "object" => "list",
                "data" => [
                ],
                "has_more" => false,
                "total_count" => 0,
                "url" => "/v1/charges/ch_1C0qrZEB8Vdfobgq37imr69C/refunds"
              },
              "review" => nil,
              "shipping" => nil,
              "source" => {
                "id" => "card_1C0qqdEB8Vdfobgqj7VnOgov",
                "object" => "card",
                "address_city" => nil,
                "address_country" => nil,
                "address_line1" => nil,
                "address_line1_check" => nil,
                "address_line2" => nil,
                "address_state" => nil,
                "address_zip" => nil,
                "address_zip_check" => nil,
                "brand" => "Visa",
                "country" => "US",
                "customer" => "cus_CPR8WVXKrhhQE2",
                "cvc_check" => "pass",
                "dynamic_last4" => nil,
                "exp_month" => 11,
                "exp_year" => 2033,
                "fingerprint" => "IUJBQB6wkybag5Sd",
                "funding" => "credit",
                "last4" => "0341",
                "metadata" => {
                },
                "name" => nil,
                "tokenization_method" => nil
              },
              "source_transfer" => nil,
              "statement_descriptor" => "failed payment",
              "status" => "failed",
              "transfer_group" => nil
            }
          },
          "livemode" => false,
          "pending_webhooks" => 1,
          "request" => {
            "id" => "req_53pE9Ltk0vq3zx",
            "idempotency_key" => nil
          },
          "type" => "charge.failed"
        }
      end

      it "deactivates a user with the webhook data from stripe", :vcr do
        alice = Fabricate(:user, customer_token: "cus_CPR8WVXKrhhQE2")
        post :create, event_data
        expect(alice.reload).not_to be_active
      end
    end
  end
end
