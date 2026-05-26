Given("eu estou na página de login do CAMAAR") do
  visit "/login"
end

Given("existe um usuário comum com email {string} e senha {string}") do |email, password|
  User.find_or_create_by(email: email) do |u|
    u.password = password
    u.role = "user"
  end
end

Given("existe um usuário com matrícula {string} e senha {string}") do |matricula, password|
  User.find_or_create_by(matricula: matricula) do |u|
    u.password = password
    u.role = "user"
  end
end

Given("existe um administrador com email {string} e senha {string}") do |email, password|
  User.find_or_create_by(email: email) do |u|
    u.password = password
    u.role = "admin"
  end
end

When("eu preencho o campo de identificação com {string}") do |value|
  fill_in("Identificação", with: value)
end

And("eu preencho o campo de senha com {string}") do |value|
  fill_in("Senha", with: value)
end

Then("eu devo ser redirecionado para o dashboard do CAMAAR") do
  expect(page).to have_current_path("/dashboard")
end

Then("eu devo ver a opção {string} no menu lateral") do |option|
  within(".sidebar-menu") { expect(page).to have_content(option) }
end

Then("eu não devo ver a opção {string} no menu lateral") do |option|
  within(".sidebar-menu") { expect(page).not_to have_content(option) }
end
