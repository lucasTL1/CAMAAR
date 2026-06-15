Given("I am logged in as a participant user") do
  user = User.find_or_create_by(email: "aluno@camaar.com") { |u| u.perfil = "discente" }
  user.nome = "Aluno" if user.nome.blank?
  user.matricula = "111111111" if user.matricula.blank?
  user.password = "password123"
  user.password_confirmation = "password123"
  user.save!

  visit new_user_session_path
  fill_in "Email", with: user.email
  fill_in "Password", with: "password123"
  click_button "Log in"
end

And("I am enrolled in the class {string}") do |class_name|
  @enrolled_classes ||= []
  @enrolled_classes << class_name
end

Given("there is an unanswered form {string} for the class {string}") do |form_name, class_name|
  template = Template.find_or_create_by!(nome: "Template #{form_name}") do |record|
    record.descricao = "Template criado para o teste de visualização de formulários."
    record.publico_alvo = "discente"
  end

  turma = Turma.find_or_create_by!(code: "CIC0105", class_code: "TA", semester: "2021.2") do |record|
    record.name = "ENGENHARIA DE SOFTWARE"
    record.time = "35M12"
  end

  Formulario.find_or_create_by!(titulo: form_name, template: template, turma: turma)
end

And("I have already answered the form {string} for the class {string}") do |form_name, class_name|
  template = Template.find_or_create_by!(nome: "Template #{form_name}") do |record|
    record.descricao = "Template criado para o teste de visualização de formulários."
    record.publico_alvo = "discente"
  end

  turma = Turma.find_or_create_by!(code: "CIC0105", class_code: "TA", semester: "2021.2") do |record|
    record.name = "ENGENHARIA DE SOFTWARE"
    record.time = "35M12"
  end

  form = Formulario.find_or_create_by!(titulo: form_name, template: template, turma: turma)

  Enrollment.find_or_create_by(user: User.find_by(email: "aluno@camaar"), turma: turma, role: "discente") do |enrollment|
    enrollment.answered_forms << form
  end
end

Then("I should see a list of unanswered forms") do
  expect(page).to have_content("Pendentes")
end

Then("I should see the questions of {string}") do |form_name|
  expect(page).to have_selector(".form-questions")
  expect(page).to have_content(form_name)
end
