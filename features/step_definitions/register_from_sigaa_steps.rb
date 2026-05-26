Given("um arquivo SIGAA contendo o participante novo {string} está disponível") do |email|
  @sigaa_participants_file = Rails.root.join("spec/fixtures/sigaa_participant_#{email.split('@').first}.json")
end

And("um arquivo SIGAA contendo o participante {string} está disponível") do |email|
  @sigaa_participants_file = Rails.root.join("spec/fixtures/sigaa_participant_#{email.split('@').first}.json")
end

And("não existe usuário cadastrado com o email {string}") do |email|
  User.where(email: email).destroy_all if defined?(User)
end

When("eu faço upload do arquivo de participantes SIGAA") do
  attach_file("participants_file", @sigaa_participants_file)
end

Then("o sistema deve criar uma solicitação de cadastro para {string}") do |email|
  expect(PendingRegistration.where(email: email)).to exist
end

And("um email de definição de senha deve ser enviado para {string}") do |email|
  expect(ActionMailer::Base.deliveries.map(&:to).flatten).to include(email)
end

And("o usuário {string} deve aparecer com status {string}") do |email, status|
  within(".user-row", text: email) { expect(page).to have_content(status) }
end

Given("existe uma solicitação de cadastro pendente para {string}") do |email|
  PendingRegistration.create!(email: email, token: SecureRandom.hex(10))
end

When("o usuário {string} acessa o link de definição de senha recebido por email") do |email|
  registration = PendingRegistration.find_by(email: email)
  visit "/users/password/define?token=#{registration.token}"
end

And("o usuário define a senha {string}") do |password|
  fill_in("Senha", with: password)
  fill_in("Confirmação", with: password)
  click_on("Definir Senha")
end

Then("o cadastro de {string} deve ser efetivado") do |email|
  expect(User.find_by(email: email)).to be_present
end

Then("o sistema não deve enviar novo email para {string}") do |email|
  expect(ActionMailer::Base.deliveries.map(&:to).flatten).not_to include(email)
end
