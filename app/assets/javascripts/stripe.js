var subscription;

jQuery(function() {
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'));
  return subscription.setupForm();
});

subscription = {
  setupForm: function() {
    return $('#new_transaction').submit(function() {
      $('#new_transaction button[type=submit]').attr('disabled', true);
      if ($('#card_number').val().length) {
        if($('#stripe_card_token').val().length == 0){
          subscription.processCard();
          return false;          
        } else {
          return true;
        }
      } else {
        return false;
      }
    });
  },

  processCard: function() {
    var card;
    card = {
      number: $('#card_number').val(),
      cvc: $('#card_code').val(),
      expMonth: $('#card_month').val(),
      expYear: $('#card_year').val()
    };
    return Stripe.createToken(card, subscription.handleStripeResponse);
  },

  handleStripeResponse: function(status, response) {
    if (status === 200) {
      $('#stripe_card_token').val(response.id);
      return $('#new_transaction').submit();
    } else {
      $('#stripe_error').text(response.error.message);
      return $('#new_transaction button[type=submit]').attr('disabled', false);
    }
  }
};