Feature: Download de resultados em CSV
  Como um Administrador
  Eu quero baixar um arquivo CSV contendo os resultados de um formulário
  A fim de avaliar o desempenho das turmas

  Background:
    Given que eu estou logado como "Administrador"

  Scenario: [Caminho Feliz] Baixar CSV de formulário respondido
    Given existe um formulário respondido chamado "Avaliação ES 2026.1"
    And eu estou na página de resultados do formulário "Avaliação ES 2026.1"
    When eu clico no botão "Baixar CSV"
    Then o navegador deve iniciar o download do arquivo "avaliacao_es_2026_1.csv"
    And o arquivo CSV deve conter o cabeçalho com as perguntas do formulário
    And o arquivo CSV deve conter uma linha por resposta enviada

  Scenario: [Caminho Triste] Formulário sem respostas não permite download
    Given existe um formulário sem respostas chamado "Avaliação BD 2026.1"
    And eu estou na página de resultados do formulário "Avaliação BD 2026.1"
    When eu clico no botão "Baixar CSV"
    Then eu devo ver a mensagem "Não há respostas para exportar"
    And nenhum arquivo CSV deve ser baixado
