class StripeHandler::ChargesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    event = Stripe::Event.retrieve(params[:id])
    if event.type == 'charge.succeeded'
      ChargeSuccess.new(event: event).process
    end

    render nothing: true, status: 201
  rescue Stripe::APIConnectionError, Stripe::StripeError
    render nothing: true, status: 400
  end
end
