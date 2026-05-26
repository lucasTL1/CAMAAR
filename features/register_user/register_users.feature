Feature: Cadastrar usuários do sistema
  Como um administrador do sistema CAMAAR
  Eu quero cadastrar novos usuários (docentes ou discentes)
  Para que eles possam ter acesso à plataforma

  Background:
    Given que eu estou logado como "Administrador"
    And eu estou na página de "Cadastro de Usuários"

  Scenario: [Caminho Feliz] Cadastro de usuário com dados válidos
    When eu preencho o campo "Nome" com "João da Silva"
    And eu preencho o campo "Matrícula" com "200012345"
    And eu preencho o campo "Email" com "joao.silva@unb.br"
    And eu seleciono o perfil "Discente"
    And eu clico no botão "Salvar Usuário"
    Then o sistema deve cadastrar o novo usuário
    And eu devo ver a mensagem verde "Usuário cadastrado com sucesso."

  Scenario: [Caminho Triste] Cadastro com email já existente
    Given já existe um usuário cadastrado com o email "joao.silva@unb.br"
    When eu preencho o campo "Nome" com "João da Silva"
    And eu preencho o campo "Matrícula" com "200012345"
    And eu preencho o campo "Email" com "joao.silva@unb.br"
    And eu seleciono o perfil "Discente"
    And eu clico no botão "Salvar Usuário"
    Then o sistema não deve cadastrar o usuário
    And eu devo ver a mensagem de erro "Este email já está em uso por outro usuário."