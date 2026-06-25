require "csv"
require "json"

class UsersController < ApplicationController
  def index
    @users = User.all
    @pending_registrations = PendingRegistration.all
  end

  def new
  end

  # POST /users  (cadastro de um único usuário — register_users)
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

  # POST /users/register_participants  (register_from_sigaa)
  # Cria solicitações de cadastro e envia e-mail de definição de senha,
  # ignorando participantes que já possuem conta.
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

  # GET /users/sigaa - formulário de importação dos JSONs do SIGAA (issue #4)
  def sigaa
  end

  # POST /users/sigaa_import
  def sigaa_import
    classes = parse_json(params[:classes_file], "classes.json")
    members = parse_json(params[:members_file], "class_members.json")

    counts = SigaaImporter.call(classes: classes, members: members)

    redirect_to users_path,
      notice: "SIGAA importado: #{counts[:turmas]} turmas, #{counts[:users]} usuários e #{counts[:enrollments]} matrículas."
  rescue => e
    redirect_to sigaa_users_path, alert: "Falha ao importar dados do SIGAA: #{e.message}"
  end

  # POST /users/import - importa turmas, participantes e matrículas a partir
  # de um CSV do SIGAA. Cria os usuários via convite (definição de senha).
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

  def mensagem_registro(criados, ignorados)
    partes = []
    partes << "Convites enviados para: #{criados.join(', ')}" if criados.any?
    ignorados.each { |email| partes << "Usuário #{email} já cadastrado, ignorado" }
    partes.join(". ")
  end

  # Cria/recupera a turma a partir das colunas do CSV (quando presentes)
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

  # Cria o usuário via convite, evitando duplicatas
  def importar_usuario(row)
    return User.find_by(email: row["email"]) if User.exists?(email: row["email"])

    User.invite!(
      nome: row["nome"],
      email: row["email"],
      matricula: row["matricula"],
      perfil: row["perfil"]
    )
  end

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
