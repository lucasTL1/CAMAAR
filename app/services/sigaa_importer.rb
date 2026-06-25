# Importa turmas, disciplinas e participantes a partir dos JSONs do SIGAA
class SigaaImporter
  def self.call(classes:, members:)
    new(classes, members).call
  end

  def initialize(classes, members)
    @classes = classes || []
    @members = members || []
    @counts  = { turmas: 0, users: 0, enrollments: 0 }
  end

  # a. Descrição: Executa a importação dos dados de classes e membros.
  # b. Argumentos: Nenhum.
  # c. Retorno: Hash com as contagens de turmas, usuários e matrículas.
  # d. Efeitos colaterais: Altera o banco de dados (inserções/atualizações).
  def call
    importar_turmas
    importar_membros
    @counts
  end

  private

  def importar_turmas
    @classes.each do |c|
      upsert_turma(c["code"], c["name"], c.dig("class", "classCode"), c.dig("class", "semester"), c.dig("class", "time"))
    end
  end

  def importar_membros
    @members.each do |m|
      turma = upsert_turma(m["code"], m["code"], m["classCode"], m["semester"], nil)
      processar_participantes(m, turma)
    end
  end

  def processar_participantes(data, turma)
    Array(data["dicente"]).each { |d| upsert_user_and_enroll(d, turma, "discente") }
    upsert_user_and_enroll(data["docente"], turma, "docente") if data["docente"].present?
  end

  def upsert_turma(code, name, class_code, semester, time)
    turma = Turma.find_or_initialize_by(code: code, class_code: class_code, semester: semester)
    if turma.new_record?
      turma.update!(name: name, time: time)
      @counts[:turmas] += 1
    elsif time.present? && turma.time.blank?
      turma.update!(time: time)
    end
    turma
  end

  def upsert_user_and_enroll(data, turma, role)
    user = encontrar_ou_criar_usuario(data, role)
    enrollment = Enrollment.find_or_initialize_by(user: user, turma: turma)
    
    if enrollment.new_record?
      enrollment.update!(role: role)
      @counts[:enrollments] += 1
    end
    enrollment
  end

  def encontrar_ou_criar_usuario(data, role)
    matricula = data["matricula"].presence || data["usuario"].presence
    user = User.find_by(matricula: matricula) || User.find_by(email: data["email"])

    unless user
      user = User.invite!(nome: data["nome"], email: data["email"], matricula: matricula, perfil: role)
      @counts[:users] += 1
    end
    user
  end
end