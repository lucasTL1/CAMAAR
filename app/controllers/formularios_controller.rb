require "csv"

class FormulariosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_formulario, only: %i[show relatorio]
  before_action :require_docente!, only: %i[new create relatorio]

  # GET /formularios
  # Docente: lista os formulários criados (issue #13).
  # Discente: lista formulários das suas turmas, separando pendentes e
  # respondidos (issue #8).
  def index
    base_query = Formulario.includes(:turma, :template)
    
    if current_user.docente?
      @formularios = base_query.order(created_at: :desc)
    else
      turma_ids = current_user.enrollments.discentes.pluck(:turma_id)
      formularios = base_query.where(turma_id: turma_ids)
      @pendentes   = formularios.reject { |form| form.respondido_por?(current_user) }
      @respondidos = formularios - @pendentes
    end
  end

  # GET /formularios/new  (issue #7)
  def new
    @templates = Template.order(:nome)
    @turmas    = Turma.order(:code, :class_code)
  end

  # POST /formularios  (issue #7)
  # Cria um formulário por turma escolhida, baseado em um template.
  def create
    template, turma_ids, titulo, prazo = extrair_parametros_formulario

    if parametros_invalidos?(template, turma_ids)
      redirect_to new_formulario_path, alert: "Selecione um template e ao menos uma turma." and return
    end

    processar_salvamento(template, turma_ids, titulo, prazo)
  end

  # GET /formularios/:id
  # Docente: resultados (issue #13). Discente: tela para responder (issue #2).
  def show
    if current_user.docente?
      render :resultados
    else
      @ja_respondido = @formulario.respondido_por?(current_user)
    end
  end

  # GET /formularios/:id/relatorio.csv  (issue #6 / #101)
  def relatorio
    respond_to do |format|
      format.csv do
        send_data gerar_csv(@formulario),
          filename: "relatorio_formulario_#{@formulario.id}.csv",
          type: "text/csv"
      end
    end
  end

  private

  def set_formulario
    @formulario = Formulario.find(params[:id])
  end

  def require_docente!
    return if current_user&.docente?
    redirect_to formularios_path, alert: "Apenas administradores (docentes) podem acessar essa área."
  end

  # Monta o CSV com as respostas do formulário
  def gerar_csv(formulario)
    CSV.generate do |csv|
      csv << [ "Formulário", formulario.titulo ]
      csv << [ "Turma", formulario.turma.nome_completo ]
      csv << [ "Respondentes", "#{formulario.total_respondentes} de #{formulario.total_participantes}" ]
      csv << []
      csv << [ "Questão", "Tipo", "Resposta" ]

      formulario.questions.each do |question|
        processar_linhas_da_questao(formulario, question, csv)
      end
    end
  end

  # a. Descrição: Verifica se os parâmetros obrigatórios para a criação estão ausentes.
  # b. Argumentos: Recebe o objeto 'template' (Template) e 'turma_ids' (Array).
  # c. Retorno: Retorna um booleano (true se faltar dados, false caso contrário).
  # d. Efeitos colaterais: Não possui alterações no banco de dados ou redirecionamentos.
  def parametros_invalidos?(template, turma_ids)
    template.nil? || turma_ids.empty?
  end

  # a. Descrição: Processa a criação em lote de formulários para as turmas selecionadas.
  # b. Argumentos: Recebe 'template' (Template), 'turma_ids' (Array), 'titulo' (String) e 'prazo' (String/Date).
  # c. Retorno: Retorna um array com as instâncias criadas ou dispara uma exceção em caso de falha.
  # d. Efeitos colaterais: Faz inserções no banco de dados dentro de uma transação.
  def salvar_formularios_em_lote(template, turma_ids, titulo, prazo)
    Formulario.transaction do
      turma_ids.each do |turma_id|
        Formulario.create!(
          template: template,
          turma_id: turma_id,
          titulo: titulo || template.nome,
          prazo: prazo
        )
      end
    end
  end

  # a. Descrição: Processa e escreve as linhas de respostas de uma questão específica diretamente no CSV.
  # b. Argumentos: Recebe 'formulario' (Formulario), 'question' (Question) e 'csv' (Objeto CSV).
  # c. Retorno: Retorna o próprio objeto CSV modificado com as novas linhas.
  # d. Efeitos colaterais: Não altera o banco de dados, apenas injeta novos dados no arquivo em memória.
  def processar_linhas_da_questao(formulario, question, csv)
    respostas = formulario.respostas_da(question)
    
    if respostas.empty?
      csv << [ question.enunciado, question.tipo, "(sem respostas)" ]
    else
      respostas.each do |resposta|
        csv << [ question.enunciado, question.tipo, resposta.valor ]
      end
    end
  end

  # a. Descrição: Extrai e sanitiza os parâmetros enviados pelo request.
  # b. Argumentos: Nenhum.
  # c. Retorno: Retorna um array contendo o template, turma_ids, titulo e prazo.
  # d. Efeitos colaterais: Nenhum.
  def extrair_parametros_formulario
    [
      Template.find_by(id: params[:template_id]),
      Array(params[:turma_ids]).reject(&:blank?),
      params[:titulo].presence,
      params[:prazo].presence
    ]
  end

  # a. Descrição: Executa o salvamento em lote e gerencia o redirecionamento ou captura de erros.
  # b. Argumentos: Recebe 'template' (Template), 'turma_ids' (Array), 'titulo' (String) e 'prazo' (String/Date).
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Redireciona a requisição com base no sucesso ou falha do salvamento.
  def processar_salvamento(template, turma_ids, titulo, prazo)
    salvar_formularios_em_lote(template, turma_ids, titulo, prazo)
    redirect_to formularios_path, notice: "Formulário criado com sucesso."
  rescue ActiveRecord::RecordInvalid => error
    redirect_to new_formulario_path, alert: "Erro ao criar formulário: #{error.message}"
  end
end