Given('I have already accessed the "Avaliação de Disciplina - Engenharia de Software" page') do
  visit '/formularios/1'
end

Given("I am logged in as a student user") do
  visit new_user_session_path
  fill_in 'Email', with: 'aluno@camaar.com'
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
end

When('I fill the multiple choice question with {string}') do |option|
  choose option
end

When('I fill the open-ended question with {string}') do |text|
  fill_in 'Deixe sugestões para a disciplina.', with: text
end

When('I click the {string} button') do |button|
  click_button button
end

Then('the system should record my answers') do
end

Then('I should be redirected to the class list') do
  expect(page).to have_current_path('/turmas')
end

Then('I should see the green message {string}') do |message|
  expect(page).to have_content(message)
  expect(page).to have_selector('.alert-success')
end

When('I do not select any option in the multiple choice question') do
end

When('I leave the open-ended question blank') do
  fill_in 'Deixe sugestões para a disciplina.', with: ''
end

Then('the system should not process the submission') do
  expect(page).to have_button('Submit Evaluation')
end

Then('I should see the alert {string}') do |message|
  expect(page).to have_content(message)
  expect(page).to have_selector('.alert-danger')
end
