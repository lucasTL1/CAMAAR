# Wiki - Sprint 1

## 1. Cabeçalho e Informações Gerais
* **Nome do Projeto:** CAMAAR
* **Escopo do Projeto:** O CAMAAR é uma plataforma para o gerenciamento de atividades acadêmicas desenvolvidas remotamente no Departamento de Ciência da Computação (CIC).
* **Integrantes da Equipe:**
    * Lucas Teles Leiro - 211066131
    * Davi Brasileiro Gomes - 241020741
    * Roberto Ribeiro Corrêa Neto - 242009936

## 2. Organização da Equipe e Papéis
* **Scrum Master:** * **Product Owner:**

## 3. Funcionalidades, Histórias de Usuário e Regras de Negócio
Todas as histórias de usuário mapeadas abaixo seguem o padrão Connextra estabelecido.

### Funcionalidade 1: Visualização de Templates Criados
* **Responsável:**Davi Brasileiro Gomes
* **Pontuação:** 3 pontos
* **História de Usuário:** [A definir]
* **Regras de Negócio:**[A definir]
    * [A definir]
    * [A definir]
    * [A definir]

### Funcionalidade 2: Busca de Templates por Palavra-Chave
* **Responsável:** Lucas Teles Leiro
* **Pontuação:** 2 pontos
* **História de Usuário:** Como um administrador do sistema CAMAAR, eu quero pesquisar por palavras-chave na barra de busca da tela de gerenciamento, para que eu encontre rapidamente um template específico sem precisar procurar manualmente em uma lista gigante.
* **Regras de Negócio:**
    * O sistema deve processar o termo inserido no campo de texto e filtrar a listagem de templates assim que o botão de busca (lupa) for acionado.
    * Havendo correspondência exata ou parcial com o título, apenas os cards filtrados devem permanecer visíveis na interface.
    * Caso nenhum template atenda ao termo pesquisado, os elementos da lista devem ser ocultados e uma mensagem explícita de "Nenhum resultado encontrado" deve ser apresentada ao usuário.

### Funcionalidade 3: [A definir]
* **Responsável:** Roberto Ribeiro Corrêa Neto
* **Pontuação:** [A atribuir]
* **História de Usuário:** [A definir]
* **Regras de Negócio:**
    * [[A definir]]

## 4. Política de Branching
A metodologia de controle de ramificações do Git adotada pelo grupo para a organização do código e prevenção de conflitos estruturais baseia-se nas seguintes diretrizes:
* **Branch de Linha Base da Sprint (`sprint-1`):** Funciona como o tronco concentrador de toda a evolução da sprint atual, ramificado a partir da `main`. É o ambiente estável onde as funcionalidades de todos os membros são unificadas.
* **Branches de Funcionalidade (`feature/`):** Cada desenvolvedor atua de forma isolada em uma ramificação específica para sua tarefa (ex: `feature-criacao_template`), criada diretamente a partir da `sprint-1`. Commits de testes BDD e especificações locais ocorrem exclusivamente nessas ramificações.
* **Processo de Integração:** Ao concluir o desenvolvimento e validar localmente as especificações, o responsável realiza a fusão (*merge*) de sua respectiva branch `feature/` de volta para a `sprint-1`, mantendo o repositório sincronizado até o fechamento da entrega.
