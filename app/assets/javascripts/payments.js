$(function() {
  var elements = stripe.elements();

  // Create an instance of the card Element
  var cardNumber = elements.create('cardNumber');
  var cardExpiry = elements.create('cardExpiry');
  var cardCvc = elements.create('cardCvc');

  // Add an instance of the card Element into the `card-element` <div>
  cardNumber.mount('#card-number');
  cardExpiry.mount('#card-expiry');
  cardCvc.mount('#card-cvc');

  // Listen for errors
  [cardNumber, cardExpiry, cardCvc].forEach(function(element, idx) {
    element.addEventListener('change', function(event) {
      var displayError = document.getElementById('card-errors');
      if (event.error) {
        displayError.textContent = event.error.message;
      } else {
        displayError.textContent = '';
      }
    });
  });

  // Look at the form element with the id and intercepts the submit event
  $('#payment-form').submit(function(event) {
    event.preventDefault();
    var $form = $(this);
    // disables the submit button so it can't be submitted again
    $form.find('.payment_submit').prop('disabled', true);
    // Comes from Stripe.js to create the token using the values
    // from the form
    // This is communicating with stripe to get a token back.
    // This is an async call.
    var cardData = {
      name: $('#user_email').val(),
    };

    stripe.createToken(cardNumber, cardData).then(stripeResponseHandler);

    return false;
  });

  var stripeResponseHandler = function(response) {
    var $form = $('#payment-form');

    // if credit card data has errors, then show them in the .card-errors element and let the form be submitted again
    if (response.error) {
      $form.find('.card-errors').text(response.error.messages);
      $form.find('.payment_submit').prop('disabled', false);
    } else {
      stripeTokenHandler(response.token);
    }
    return false;
  }

  var stripeTokenHandler = function(token) {
    var $form = $('#payment-form');
    // if no errors, take the response.id as the token and insert
    // a hidden field into the form that will then be submitted.
    var $hiddenStripeToken = $('<input>');
    $hiddenStripeToken.attr('type', 'hidden');
    $hiddenStripeToken.attr('name', 'stripeToken');
    $hiddenStripeToken.attr('value', token.id);
    $form.append($hiddenStripeToken);

    // var $hiddenStripeEmail = $('<input>');
    // $hiddenStripeEmail.attr('type', 'hidden');
    // $hiddenStripeEmail.attr('name', 'stripeEmail');
    // $hiddenStripeEmail.attr('value', $('#user_email').val());
    // $form.append($hiddenStripeEmail);
    //
    $form.get(0).submit();
  }
});
