Feature: Importação inicial de dados do SIGAA
  Como um Administrador
  Eu quero importar dados de turmas, matérias e participantes do SIGAA caso não existam na base
  A fim de alimentar a base de dados do sistema

  Background:
    Given que eu estou logado como "Administrador"
    And a base de dados do sistema está vazia
    And eu navego para a página de "Importação SIGAA"

  Scenario: [Caminho Feliz] Importar dados SIGAA inexistentes
    Given um arquivo SIGAA válido com turmas, matérias e participantes está disponível
    When eu faço upload do arquivo SIGAA de importação
    And eu clico no botão "Importar Dados"
    Then o sistema deve criar as turmas no banco de dados
    And o sistema deve criar as matérias no banco de dados
    And o sistema deve criar os participantes no banco de dados
    And eu devo ver a mensagem "Dados do SIGAA importados com sucesso"

  Scenario: Ignorar registros já existentes durante importação
    Given já existe a turma "CIC0097" no sistema
    And um arquivo SIGAA válido contendo a turma "CIC0097" está disponível
    When eu faço upload do arquivo SIGAA de importação
    And eu clico no botão "Importar Dados"
    Then a turma "CIC0097" não deve ser duplicada no banco de dados
    And eu devo ver a mensagem "Importação concluída: registros existentes preservados"
