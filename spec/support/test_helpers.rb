module Trackerapp::TestHelpers

  def login_user_with_request(user)
    page.driver.post(sessions_path, { username: user.email, password: 'secret'})
  end

  def login_user_manually(user)
    visit login_path
    fill_in 'username', with: @user.email
    fill_in 'password', with: "secret"
    click_button 'Log in'
  end

end
