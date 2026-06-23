Given("the user is on the login page") do
  visit(new_user_session_path)
end

When("the user fills {string} in the username field") do |field|
  fill_in("Email", with: field)
end

When("the user fills {string} in the password field") do |field|
  fill_in("Password", with: field)
  click_button("Log in")
end

Then("the user should be redirected to the dashboard") do
  expect(page).to have_current_path('/')
end

Then("an error message should be displayed with {err}") do |err|
  expect(page).to have_content(err)
end

When("the user leaves {string} field empty") do |field|
  fill_in(field, with: "")
end
And("the user leaves {string} field empty") do |field|
  fill_in(field, with: "")
end
