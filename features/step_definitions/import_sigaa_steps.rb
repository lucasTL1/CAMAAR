Then("eu devo ver a mensagem {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

And("a base de dados do sistema está vazia") do
  Klass.destroy_all if defined?(Klass)
  Subject.destroy_all if defined?(Subject)
  User.where.not(role: "admin").destroy_all if defined?(User)
end

And("eu navego para a página de {string}") do |page|
  paths = {
    "Importação SIGAA" => "/admin/import"
  }
  visit(paths[page] || "/admin/#{page.downcase.tr(' ', '_')}")
end

Given("um arquivo SIGAA válido com turmas, matérias e participantes está disponível") do
  @sigaa_full_file = Rails.root.join("spec/fixtures/sigaa_full_valid.json")
end

When("eu faço upload do arquivo SIGAA de importação") do
  attach_file("sigaa_file", @sigaa_full_file)
end

Then("o sistema deve criar as turmas no banco de dados") do
  expect(Klass.count).to be > 0
end

And("o sistema deve criar as matérias no banco de dados") do
  expect(Subject.count).to be > 0
end

And("o sistema deve criar os participantes no banco de dados") do
  expect(User.where.not(role: "admin").count).to be > 0
end

Given("já existe a turma {string} no sistema") do |code|
  Klass.find_or_create_by(code: code)
end

And("um arquivo SIGAA válido contendo a turma {string} está disponível") do |code|
  @sigaa_full_file = Rails.root.join("spec/fixtures/sigaa_with_#{code}.json")
end

Then("a turma {string} não deve ser duplicada no banco de dados") do |code|
  expect(Klass.where(code: code).count).to eq(1)
end
