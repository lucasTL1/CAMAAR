Given("I have created a form called {string}") do |form_name|
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

When("I navigate to the forms page") do
  visit("/formularios")
end

Then("I should see a list of created forms") do
  expect(page).to have_content("Formulários")
end

And("I click on the form named {string}") do |form_name|
  click_link(form_name)
end

Then("I should see a message {string}") do |message|
  expect(page).to have_content(message)
end
