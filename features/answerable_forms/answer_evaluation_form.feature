Feature: Responder formulário de avaliação
  Como um discente do sistema CAMAAR
  Eu quero preencher e enviar as respostas de um formulário de avaliação
  Para concluir minha avaliação da disciplina

  Background:
    Given que eu estou logado como um usuário discente
    And eu já acessei a página do formulário da disciplina "Engenharia de Software"

  Scenario: [Caminho Feliz] Envio de formulário com todas as respostas preenchidas
    When eu preencho a questão de múltipla escolha com "Excelente"
    And eu preencho a questão discursiva com "O conteúdo foi muito bem ministrado."
    And eu clico no botão "Enviar Avaliação"
    Then o sistema deve registrar minhas respostas
    And eu devo ser redirecionado para a lista de turmas
    And eu devo ver a mensagem verde "Avaliação enviada com sucesso!"

  Scenario: [Caminho Triste] Tentativa de envio com perguntas obrigatórias em branco
    When eu não seleciono nenhuma opção na questão de múltipla escolha
    And eu deixo a questão discursiva em branco
    And eu clico no botão "Enviar Avaliação"
    Then o sistema não deve processar o envio
    And eu devo ver o alerta "Existem questões obrigatórias não respondidas."