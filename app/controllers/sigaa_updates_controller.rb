require "csv"

# Atualização da base com os dados atuais do SIGAA (update_database).
# Faz upsert de turmas/usuários/matrículas preservando formulários e
# templates já existentes.
class SigaaUpdatesController < ApplicationController
  before_action :authenticate_user!

  # GET /sigaa/atualizar
  def new
  end

  # POST /sigaa/atualizar
  def create
    file = params[:sigaa_file]
    rows = ler_linhas(file)

    if rows.nil? || rows.empty?
      redirect_to root_path, alert: "Arquivo SIGAA inválido" and return
    end

    rows.each { |row| importar_linha(row) }

    redirect_to root_path,
      notice: "Base de dados atualizada com sucesso. Dados atualizados conforme o SIGAA."
  end

  private

  def ler_linhas(file)
    return nil unless file.respond_to?(:path)

    conteudo = File.read(file.path).strip
    return [] if conteudo.empty?

    CSV.parse(conteudo, headers: true)
  rescue CSV::MalformedCSVError
    nil
  end

  def importar_linha(row)
    turma = upsert_turma(row)
    user  = upsert_user(row)
    return unless user && turma

    role = (row["perfil"] == "docente") ? "docente" : "discente"
    Enrollment.find_or_create_by!(user: user, turma: turma) { |e| e.role = role }
  end

  def upsert_turma(row)
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

  def upsert_user(row)
    return User.find_by(email: row["email"]) if User.exists?(email: row["email"])

    User.invite!(
      nome: row["nome"],
      email: row["email"],
      matricula: row["matricula"],
      perfil: row["perfil"]
    )
  end
end
