# Wiki - Sprint 1

## [cite_start]1. Cabeçalho e Informações Gerais [cite: 44, 45]
* [cite_start]**Nome do Projeto:** CAMAAR [cite: 45]
* [cite_start]**Escopo do Projeto:** O CAMAAR é uma plataforma para o gerenciamento de atividades acadêmicas desenvolvidas remotamente no Departamento de Ciência da Computação (CIC). [cite: 45]
* [cite_start]**Integrantes da Equipe:** [cite: 45]
    * [cite_start]Lucas Teles Leiro - 211066131 [cite: 45]
    * [cite_start]Davi Brasileiro Gomes - 241020741 [cite: 45]
    * [cite_start]Roberto Ribeiro Corrêa Neto - 242009936 [cite: 45]

## [cite_start]2. Organização da Equipe e Papéis [cite: 46, 47]
* [cite_start]**Scrum Master:**  [cite: 46]
* [cite_start]**Product Owner:** [cite: 47]

## [cite_start]3. Funcionalidades, Histórias de Usuário e Regras de Negócio [cite: 21, 48, 49]
[cite_start]Todas as histórias de usuário mapeadas abaixo seguem o padrão Connextra estabelecido[cite: 23].

### [cite_start]Funcionalidade 1: Visualização de Templates Criados [cite: 48, 50]
* [cite_start]**Responsável:**Davi Brasileiro Gomes [cite: 50]
* [cite_start]**Pontuação:** 3 pontos [cite: 52]
* [cite_start]**História de Usuário:** [A definir] [cite: 23]
* [cite_start]**Regras de Negócio:**[A definir] [cite: 48, 49]
    * [cite_start][A definir][cite: 48, 49]
    * [cite_start][A definir] [cite: 48, 49]
    * [cite_start][A definir] [cite: 48, 49]

### [cite_start]Funcionalidade 2: Busca de Templates por Palavra-Chave [cite: 48, 50]
* [cite_start]**Responsável:** Lucas Teles Leiro [cite: 50]
* [cite_start]**Pontuação:** 2 pontos [cite: 52]
* [cite_start]**História de Usuário:** Como um administrador do sistema CAMAAR, eu quero pesquisar por palavras-chave na barra de busca da tela de gerenciamento, para que eu encontre rapidamente um template específico sem precisar procurar manualmente em uma lista gigante. [cite: 23]
* [cite_start]**Regras de Negócio:** [cite: 48, 49]
    * [cite_start]O sistema deve processar o termo inserido no campo de texto e filtrar a listagem de templates assim que o botão de busca (lupa) for acionado. [cite: 48, 49]
    * [cite_start]Havendo correspondência exata ou parcial com o título, apenas os cards filtrados devem permanecer visíveis na interface. [cite: 48, 49]
    * [cite_start]Caso nenhum template atenda ao termo pesquisado, os elementos da lista devem ser ocultados e uma mensagem explícita de "Nenhum resultado encontrado" deve ser apresentada ao usuário. [cite: 48, 49]

### [cite_start]Funcionalidade 3: [A definir] [cite: 48, 50]
* [cite_start]**Responsável:** Roberto Ribeiro Corrêa Neto [cite: 50]
* [cite_start]**Pontuação:** [A atribuir] [cite: 52]
* [cite_start]**História de Usuário:** [A definir] [cite: 23]
* [cite_start]**Regras de Negócio:** [cite: 48, 49]
    * [cite_start][[A definir]] [cite: 48, 49]

## [cite_start]4. Política de Branching [cite: 51]
[cite_start]A metodologia de controle de ramificações do Git adotada pelo grupo para a organização do código e prevenção de conflitos estruturais baseia-se nas seguintes diretrizes: [cite: 51]
* **Branch de Linha Base da Sprint (`sprint-1`):** Funciona como o tronco concentrador de toda a evolução da sprint atual, ramificado a partir da `main`. [cite_start]É o ambiente estável onde as funcionalidades de todos os membros são unificadas. [cite: 51]
* **Branches de Funcionalidade (`feature/`):** Cada desenvolvedor atua de forma isolada em uma ramificação específica para sua tarefa (ex: `feature-criacao_template`), criada diretamente a partir da `sprint-1`. [cite_start]Commits de testes BDD e especificações locais ocorrem exclusivamente nessas ramificações. [cite: 51]
* [cite_start]**Processo de Integração:** Ao concluir o desenvolvimento e validar localmente as especificações, o responsável realiza a fusão (*merge*) de sua respectiva branch `feature/` de volta para a `sprint-1`, mantendo o repositório sincronizado até o fechamento da entrega. [cite: 51]
