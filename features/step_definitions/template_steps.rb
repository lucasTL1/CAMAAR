Given("I am logged in as an admin user") do
  admin = User.find_or_initialize_by(email: "admin@camaar.com")
  admin.nome = "Administrador" if admin.nome.blank?
  admin.matricula = "000000000" if admin.matricula.blank?
  admin.perfil = "docente"
  admin.password = "password123"
  admin.password_confirmation = "password123"
  admin.save!

  visit(new_user_session_path)
  fill_in('Email', with: admin.email)
  fill_in('Password', with: 'password123')
  click_button('Log in')
end

Given("I have created a template with the name {string}") do |name|
  # logic to create a template with the given name
end

And("I am on the dashboard page") do
  visit("/")
end

And("the list should include {string}") do |template_name|
  expect(page).to have_content(template_name)
end

And("I click on the template named {string}") do |template_name|
  click_link(template_name)
end

And("the details should include the name {string}") do |template_name|
  expect(page).to have_content(template_name)
end

When("I navigate to the templates page") do
  visit("/templates")
end

Then("I should see a list of created templates") do
  expect(page).to have_selector(".template-list")
end

Then("I should see the details of {string}") do |template_name|
  expect(page).to have_content(template_name)
end
