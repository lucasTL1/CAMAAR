Given('eu já acessei a página do formulário da disciplina {string}') do |disciplina|
  visit "/avaliacoes/responder/#{disciplina.downcase.tr(' ', '_')}"
end

When('eu preencho a questão de múltipla escolha com {string}') do |opcao|
  choose opcao
end

When('eu preencho a questão discursiva com {string}') do |texto|
  fill_in 'Questão Discursiva', with: texto
end

When('eu clico no botão {string}') do |botao|
  click_button botao
end

Then('o sistema deve registrar minhas respostas') do
end

Then('eu devo ser redirecionado para a lista de turmas') do
  expect(page).to have_current_path('/turmas')
end

Then('eu devo ver a mensagem verde {string}') do |mensagem|
  expect(page).to have_content(mensagem)
  expect(page).to have_selector('.alert-success')
end

When('eu não seleciono nenhuma opção na questão de múltipla escolha') do
end

When('eu deixo a questão discursiva em branco') do
  fill_in 'Questão Discursiva', with: ''
end

Then('o sistema não deve processar o envio') do
  expect(page).to have_button('Enviar Avaliação')
end

Then('eu devo ver o alerta {string}') do |mensagem|
  expect(page).to have_content(mensagem)
  expect(page).to have_selector('.alert-danger')
end