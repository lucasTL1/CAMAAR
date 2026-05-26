Given('que eu estou logado como {string}') do |perfil|
  visit '/login'
  fill_in 'Usuário', with: 'admin'
  fill_in 'Senha', with: 'admin123'
  click_button 'Entrar'
end

Given('eu estou na página de {string}') do |pagina|
  visit '/usuarios/novo'
end

When('eu preencho o campo {string} com {string}') do |campo, valor|
  fill_in campo, with: valor
end

When('eu seleciono o perfil {string}') do |perfil|
  select perfil, from: 'Perfil de Acesso'
end

When('eu clico no botão {string}') do |botao|
  click_button botao
end

Then('o sistema deve cadastrar o novo usuário') do
  expect(page).to have_current_path('/usuarios')
end

Then('eu devo ver a mensagem verde {string}') do |mensagem|
  expect(page).to have_content(mensagem)
  expect(page).to have_selector('.alert-success')
end

Given('já existe um usuário cadastrado com o email {string}') do |email|
  @usuario_existente = email
end

Then('o sistema não deve cadastrar o usuário') do
  expect(page).to have_current_path('/usuarios/novo')
end

Then('eu devo ver a mensagem de erro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
  expect(page).to have_selector('.alert-danger')
end