def set_current_user(user = nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def current_user
  User.find session[:user_id]
end

def set_current_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in 'Email Address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end

def sign_out
  visit sign_out_path
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end

def fill_in_valid_card
  fill_in_valid_credit_card_number

  within_frame("__privateStripeFrame4") do
    find_field('exp-date').send_keys("1121")
  end

  within_frame("__privateStripeFrame5") do
    find_field('cvc').send_keys("123")
  end
end

def fill_in_invalid_card
  fill_in_invalid_credit_card_number

  within_frame("__privateStripeFrame4") do
    find_field('exp-date').send_keys("1121")
  end

  within_frame("__privateStripeFrame5") do
    find_field('cvc').send_keys("123")
  end
end

def fill_in_declined_card
  fill_in_declined_credit_card_number

  within_frame("__privateStripeFrame4") do
    find_field('exp-date').send_keys("1121")
  end

  within_frame("__privateStripeFrame5") do
    find_field('cvc').send_keys("123")
  end
end

def fill_in_valid_credit_card_number
  within_frame("__privateStripeFrame3") do
    find_field('cardnumber').send_keys("4242424242424242")
  end
end

def fill_in_invalid_credit_card_number
  within_frame("__privateStripeFrame3") do
    find_field('cardnumber').send_keys("4242424242424241")
  end
end

def fill_in_declined_credit_card_number
  within_frame("__privateStripeFrame3") do
    find_field('cardnumber').send_keys("4000000000000002")
  end
end
