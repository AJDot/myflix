require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "valid personal info and valid card" do
      let(:customer) { double(:customer, successful?: true, response: {id: '12345'}, customer_token: "abcdefg") }
      let(:subscription) { double(:subscription, successful?: true) }

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        StripeWrapper::Subscription.should_receive(:create).and_return(subscription)
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "creates the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.first.customer_token).to eq('abcdefg')
      end

      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', full_name: 'Joe Doe')).sign_up("some_stripe_token", invitation.token)
        joe = User.find_by email: 'joe@example.com'
        expect(joe.follows?(alice)).to be true
      end

      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', full_name: 'Joe Doe')).sign_up("some_stripe_token", invitation.token)
        joe = User.find_by email: 'joe@example.com'
        expect(alice.follows?(joe)).to be true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', full_name: 'Joe Doe')).sign_up("some_stripe_token", invitation.token)
        expect(Invitation.first.token).to be_nil
      end

      it "sends out email to the user with valid inputs" do
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end

      it "sends out email containing the user's name with valid inputs" do
        UserSignup.new(Fabricate.build(:user, full_name: "Joe Smith", email: 'joe@example.com')).sign_up("some_stripe_token", nil)
        expect(ActionMailer::Base.deliveries.last.body).to include("Joe Smith")
      end
    end

    context "with valid personal info and declined card" do
      it "does not create a new user record" do
        customer = double(:charge, successful?: false, error_message: "Your card was declined.")
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up('12345', nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid person info" do
      it "does not create the user" do
        UserSignup.new(User.new(email: "alex@example.com")).sign_up('12345', nil)
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        StripeWrapper::Customer.should_not_receive(:create)
        UserSignup.new(User.new(email: "alex@example.com")).sign_up('12345', nil)
      end

      it "does not send out email with invalid inputs" do
        UserSignup.new(User.new(email: "alex@example.com")).sign_up('12345', nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
