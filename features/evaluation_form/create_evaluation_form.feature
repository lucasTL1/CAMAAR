Feature: Criar formulário de avaliação
  Como um docente do sistema CAMAAR
  Eu quero criar um formulário de avaliação baseado em um template
  Para enviá-lo à minha turma

  Background:
    Given que eu estou logado como "Docente"
    And eu acesso a página de "Novo Formulário"

  Scenario: [Caminho Feliz] Criação de formulário completo
    When eu escolho o template "Avaliação Final de Semestre"
    And eu vinculo à turma "Engenharia de Software - Turma A"
    And eu preencho a "Data Limite" com "15/12/2026"
    And eu clico no botão "Criar Formulário"
    Then o formulário deve ser salvo no banco de dados
    And a turma "Engenharia de Software - Turma A" deve ser notificada
    And eu devo ver a mensagem "Formulário criado e enviado aos alunos."

  Scenario: [Caminho Triste] Falta de data limite
    When eu escolho o template "Avaliação Final de Semestre"
    And eu vinculo à turma "Engenharia de Software - Turma A"
    And eu deixo o campo "Data Limite" em branco
    And eu clico no botão "Criar Formulário"
    Then o formulário não deve ser criado
    And eu devo ver o alerta "A data limite de resposta é obrigatória."