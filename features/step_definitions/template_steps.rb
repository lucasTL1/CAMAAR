Given("I am logged in as an admin user") do
  # user validation and login steps
end

Given("I have created a template with the name {name}") do |name|
  # Implementation for creating a template
end

And("I am on the dashboard page") do
  visit("/")
end

And("the list should include {template_name}") do |template_name|
  expect(page).to have_content(template_name)
end

And("I click on the template named {template_name}") do |template_name|
  click_link(template_name)
end

And("I have created a template with the name {template_name}") do |template_name|
  # Implementation for creating a template
end

And("the details should include the name {template_name}") do |template_name|
  expect(page).to have_content(template_name)
end

When("I navigate to the templates page") do
  visit("/templates")
end

Then("I should see a list of created templates") do
  expect(page).to have_selector(".template-list")
end

Then("I should see the details of {template_name}") do |template_name|
  # Implementation for checking the details of the template
end
