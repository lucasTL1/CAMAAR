Feature: Cadastro de participantes via importação SIGAA
  Como um Administrador
  Eu quero cadastrar participantes ao importar dados de novos usuários do SIGAA
  A fim de que eles acessem o sistema CAMAAR

  Observação: O cadastro é efetivado apenas após o usuário definir sua senha via email recebido.

  Background:
    Given que eu estou logado como "Administrador"
    And eu navego para a página de "Importação SIGAA"

  Scenario: [Caminho Feliz] Solicitar definição de senha para novos participantes
    Given um arquivo SIGAA contendo o participante novo "maria@unb.br" está disponível
    And não existe usuário cadastrado com o email "maria@unb.br"
    When eu faço upload do arquivo de participantes SIGAA
    And eu clico no botão "Cadastrar Participantes"
    Then o sistema deve criar uma solicitação de cadastro para "maria@unb.br"
    And um email de definição de senha deve ser enviado para "maria@unb.br"
    And o usuário "maria@unb.br" deve aparecer com status "Aguardando definição de senha"

  Scenario: Cadastro efetivado após definição de senha
    Given existe uma solicitação de cadastro pendente para "maria@unb.br"
    When o usuário "maria@unb.br" acessa o link de definição de senha recebido por email
    And o usuário define a senha "SenhaForte123"
    Then o cadastro de "maria@unb.br" deve ser efetivado
    And o usuário "maria@unb.br" deve aparecer com status "Ativo"

  Scenario: [Caminho Triste] Participante já cadastrado é ignorado
    Given já existe um usuário cadastrado com o email "joao@unb.br"
    And um arquivo SIGAA contendo o participante "joao@unb.br" está disponível
    When eu faço upload do arquivo de participantes SIGAA
    And eu clico no botão "Cadastrar Participantes"
    Then o sistema não deve enviar novo email para "joao@unb.br"
    And eu devo ver a mensagem "Usuário joao@unb.br já cadastrado, ignorado"
