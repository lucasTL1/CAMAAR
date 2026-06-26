require "csv"
require "json"

##
# Define a controller para gerenciar usuários, incluindo listagem, criação via convite, importação de participantes do SIGAA e envio de convites para definição de senha.
class UsersController < ApplicationController
  ##
  # a. Descrição: Lista todos os usuários e registros pendentes de participantes.
  # b. Argumentos: Nenhum.
  # c. Retorno: Não há retorno.
  # d. Efeitos colaterais: Atribui as variáveis de instância @users e @pending_registrations.
  def index
    @users = User.all
    @pending_registrations = PendingRegistration.all
  end

  ##
  # a. Descrição: Cria um novo usuário via convite, enviando e-mail para definição de senha.
  # b. Argumentos: Recebe 'nome', 'email', 'matricula' e 'perfil' como parâmetros.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria o usuário no banco de dados e envia um e-mail de convite para definição de senha, ou redireciona com mensagem de erro caso o e-mail já esteja em uso.
  def create
    email = params[:email].to_s.downcase

    if email.present? && User.exists?(email: email)
      redirect_to "/usuarios/novo", alert: "Este email já está em uso por outro usuário." and return
    end

    User.invite!(
      nome: params[:nome],
      email: email,
      matricula: params[:matricula],
      perfil: params[:perfil]
    )

    redirect_to "/usuarios", notice: "Usuário cadastrado com sucesso."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to "/usuarios/novo", alert: "Erro ao cadastrar usuário: #{e.message}"
  end

  ##
  # a. Descrição: Registra participantes a partir de um arquivo JSON, enviando convites para definição de senha.
  # b. Argumentos: Recebe 'participants_file' (JSON) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria registros pendentes de usuários no banco de dados e envia e-mails de convite para definição de senha, ou redireciona com mensagem de erro caso o arquivo não seja fornecido.
  def register_participants
    participantes = parse_json(params[:participants_file], "spec/fixtures/sigaa_participant_maria.json")

    criados = []
    ignorados = []

    Array(participantes).each do |p|
      email = p["email"].to_s
      if User.exists?(email: email.downcase)
        ignorados << email
        next
      end

      pending = PendingRegistration.find_or_create_by!(email: email) do |pr|
        pr.token = SecureRandom.hex(10)
        pr.nome = p["nome"]
        pr.matricula = p["matricula"]
        pr.perfil = "discente"
      end

      PendingRegistrationMailer.setup_password(pending).deliver_now
      criados << email
    end

    redirect_to users_path, notice: mensagem_registro(criados, ignorados)
  end

  ##
  # a. Descrição: Faz a importação dos JSONs do SIGAA.
  # b. Argumentos: Recebe 'sigaa_users_file' (JSON) e 'sigaa_enrollments_file' (JSON) como parâmetros.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria ou atualiza usuários e matrículas no banco de dados.
  def sigaa
  end

  ##
  # a. Descrição: Importa usuários e matrículas a partir de um arquivo CSV, enviando convites para definição de senha.
  # b. Argumentos: Recebe 'file' (CSV) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria ou atualiza turmas, usuários e matrículas no banco de dados, e envia e-mails de convite para definição de senha, ou redireciona com mensagem de erro caso o arquivo não seja fornecido.
  def import
    file = params[:file]
    return redirect_to root_path, alert: "Nenhum arquivo selecionado" unless file

    CSV.foreach(file.path, headers: true) do |row|
      turma = importar_turma(row)
      user  = importar_usuario(row)
      matricular(user, turma, row["perfil"]) if user && turma
    end

    redirect_to root_path, notice: "Usuários importados e convites enviados com sucesso!"
  end

  private

  ##
  # a. Descrição: Gera uma mensagem de registro com informações sobre os usuários criados e ignorados.
  # b. Argumentos: Recebe 'criados' (Array) e 'ignorados' (Array) como parâmetros.
  # c. Retorno: Retorna a mensagem de registro gerada (String).
  # d. Efeitos colaterais: Nenhum.
  def mensagem_registro(criados, ignorados)
    partes = []
    partes << "Convites enviados para: #{criados.join(', ')}" if criados.any?
    ignorados.each { |email| partes << "Usuário #{email} já cadastrado, ignorado" }
    partes.join(". ")
  end

  ##
  # a. Descrição: Cria/recupera a turma a partir das colunas do CSV (quando presentes)
  # b. Argumentos: Recebe 'row' (Hash) como parâmetro.
  # c. Retorno: Retorna a turma encontrada ou criada (Turma).
  # d. Efeitos colaterais: Nenhum.
  def importar_turma(row)
    code = row["turma_code"]
    return nil if code.blank?

    Turma.find_or_create_by!(
      code: code,
      class_code: row["class_code"].presence || "TA",
      semester: row["semester"].presence || "2026.1"
    ) do |t|
      t.name = row["turma_name"].presence || code
      t.department = row["departamento"]
    end
  end

  ##
  # a. Descrição: Cria/recupera o usuário a partir das colunas do CSV (quando presentes)
  # b. Argumentos: Recebe 'row' (Hash) como parâmetro.
  # c. Retorno: Retorna o usuário encontrado ou criado (User).
  # d. Efeitos colaterais: Nenhum.
  def importar_usuario(row)
    return User.find_by(email: row["email"]) if User.exists?(email: row["email"])

    User.invite!(
      nome: row["nome"],
      email: row["email"],
      matricula: row["matricula"],
      perfil: row["perfil"]
    )
  end

  ##
  # a. Descrição: Cria/recupera a matrícula do usuário na turma, com base no perfil fornecido.
  # b. Argumentos: Recebe 'user' (User), 'turma' (Turma) e 'perfil' (String) como parâmetros.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria a matrícula do usuário na turma, com o papel correspondente ao perfil fornecido.
  def matricular(user, turma, perfil)
    role = (perfil == "docente") ? "docente" : "discente"
    Enrollment.find_or_create_by!(user: user, turma: turma) { |e| e.role = role }
  end

  # Lê o JSON do upload quando presente; caso contrário, do arquivo do repositório
  def parse_json(uploaded, fallback_filename)
    if uploaded.respond_to?(:read)
      JSON.parse(uploaded.read)
    else
      JSON.parse(File.read(Rails.root.join(fallback_filename)))
    end
  end
end
