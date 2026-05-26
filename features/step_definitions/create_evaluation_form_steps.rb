Given('eu acesso a página de {string}') do |pagina|
  visit '/formularios/novo'
end

When('eu escolho o template {string}') do |template|
  select template, from: 'Template Base'
end

When('eu vinculo à turma {string}') do |turma|
  select turma, from: 'Turma Destino'
end

When('eu deixo o campo {string} em branco') do |campo|
  fill_in campo, with: ''
end

Then('o formulário deve ser salvo no banco de dados') do
  expect(page).to have_current_path('/formularios')
end

Then('a turma {string} deve ser notificada') do |turma|
end

Then('eu devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Then('o formulário não deve ser criado') do
  expect(page).to have_current_path('/formularios/novo')
end

Then('eu devo ver o alerta {string}') do |mensagem|
  expect(page).to have_content(mensagem)
  expect(page).to have_selector('.alert-warning')
end