Feature: Login com email ou matrícula e exibição de menu administrativo
  Como um Usuário do sistema
  Eu quero acessar o sistema com email ou matrícula e senha já cadastrada
  A fim de responder formulários ou gerenciar o sistema

  Observação: Quando o usuário logado é admin, a opção de gerenciamento aparece no menu lateral.

  Background:
    Given eu estou na página de login do CAMAAR

  Scenario: [Caminho Feliz] Login com email válido
    Given existe um usuário comum com email "user@unb.br" e senha "Senha123"
    When eu preencho o campo de identificação com "user@unb.br"
    And eu preencho o campo de senha com "Senha123"
    And eu clico no botão "Entrar"
    Then eu devo ser redirecionado para o dashboard do CAMAAR

  Scenario: Login com matrícula válida
    Given existe um usuário com matrícula "200012345" e senha "Senha123"
    When eu preencho o campo de identificação com "200012345"
    And eu preencho o campo de senha com "Senha123"
    And eu clico no botão "Entrar"
    Then eu devo ser redirecionado para o dashboard do CAMAAR

  Scenario: Menu administrativo visível para admin
    Given existe um administrador com email "admin@unb.br" e senha "AdminPass"
    When eu preencho o campo de identificação com "admin@unb.br"
    And eu preencho o campo de senha com "AdminPass"
    And eu clico no botão "Entrar"
    Then eu devo ver a opção "Gerenciamento" no menu lateral

  Scenario: Menu administrativo oculto para usuário comum
    Given existe um usuário comum com email "user@unb.br" e senha "Senha123"
    When eu preencho o campo de identificação com "user@unb.br"
    And eu preencho o campo de senha com "Senha123"
    And eu clico no botão "Entrar"
    Then eu não devo ver a opção "Gerenciamento" no menu lateral

  Scenario: [Caminho Triste] Credenciais inválidas
    When eu preencho o campo de identificação com "user@unb.br"
    And eu preencho o campo de senha com "SenhaErrada"
    And eu clico no botão "Entrar"
    Then eu devo ver a mensagem de erro "Identificação ou senha inválida"
