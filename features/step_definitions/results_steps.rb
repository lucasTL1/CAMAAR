
Given ("I am logged in as {string}") do |user_email|
  user = User.find_by(email: user_email)
  login_as(user, scope: :user)
end

Given ("I am on the {page} page") do |page|
  visit send("#{page}_path")
end

And ("I have created a form called {name}") do |name|
  @form = Form.create(name: name)
end

And ("I click on the {form_name} form") do |form_name|
  click_link(form_name)
end

Then ("I should see the results for the {form_name} form") do |form_name|
  expect(page).to have_content("Results for #{form_name}")
end

Then ("I should see a message indicating that there are no results for the {form_name} form") do |form_name|
  expect(page).to have_content("No results available for #{form_name}")
end