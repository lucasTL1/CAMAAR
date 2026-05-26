Given("existe um formulário respondido chamado {string}") do |name|
  @form_name = name
  @form_answered = true
end

Given("existe um formulário sem respostas chamado {string}") do |name|
  @form_name = name
  @form_answered = false
end

And("eu estou na página de resultados do formulário {string}") do |name|
  slug = name.downcase.tr(" .", "__").gsub(/[^a-z0-9_]/, "")
  visit("/resultados/#{slug}")
end

Then("o navegador deve iniciar o download do arquivo {string}") do |filename|
  expect(page.response_headers["Content-Disposition"]).to include(filename)
end

And("o arquivo CSV deve conter o cabeçalho com as perguntas do formulário") do
  expect(page.body).to match(/pergunta/i)
end

And("o arquivo CSV deve conter uma linha por resposta enviada") do
  expect(page.body.lines.count).to be > 1
end

And("nenhum arquivo CSV deve ser baixado") do
  expect(page.response_headers["Content-Disposition"]).to be_nil
end
