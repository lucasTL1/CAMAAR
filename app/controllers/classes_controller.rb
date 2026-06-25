# Gestão das turmas do departamento do administrador logado (issue de gestão
# de turmas). O admin só enxerga/edita turmas do próprio departamento no
# semestre atual.
class ClassesController < ApplicationController
  before_action :authenticate_user!

  CURRENT_SEMESTER = "2026.1".freeze

  # GET /classes
  def index
    @semester = CURRENT_SEMESTER
    @turmas = turmas_do_departamento.where(semester: @semester).order(:code)
  end

  # GET /classes/:code
  def show
    @turma = turmas_do_departamento.find_by(code: params[:code])

    if @turma.nil?
      redirect_to classes_path, alert: "Acesso negado: turma fora do seu departamento" and return
    end

    @discentes = @turma.discentes
  end

  # GET /classes/:code/edit
  def edit
    @turma = turmas_do_departamento.find_by(code: params[:code])
    redirect_to classes_path, alert: "Acesso negado: turma fora do seu departamento" if @turma.nil?
  end

  # PATCH /classes/:code
  def update
    @turma = turmas_do_departamento.find_by(code: params[:code])

    if @turma.nil?
      redirect_to classes_path, alert: "Acesso negado: turma fora do seu departamento" and return
    end

    @turma.update(professor: params[:professor])
    redirect_to classes_path, notice: "Turma atualizada com sucesso"
  end

  private

  # Turmas do departamento do admin. Caso o admin não tenha departamento
  # definido, retorna todas (evita esconder tudo em ambientes sem o dado).
  def turmas_do_departamento
    if current_user.department.present?
      Turma.where(department: current_user.department)
    else
      Turma.all
    end
  end
end
