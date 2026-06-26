##
# Define a model Turma, representando uma turma de curso, com suas associações, validações e métodos auxiliares.
# == Schema:
#  * id: integer, primary key
#  * code: string, código do curso
#  * name: string, nome do curso
#  * class_code: string, código da turma
#  * semester: string, semestre da turma
#  * departamento: string, departamento responsável pela turma
class Turma < ApplicationRecord
  # Os step definitions (BDD) usam o nome em inglês "department"; o banco usa
  # "departamento". O alias mantém ambos funcionando em queries e setters.
  alias_attribute :department, :departamento

  has_many :enrollments, dependent: :destroy
  has_many :users, through: :enrollments
  has_many :formularios, dependent: :destroy

  validates :code, :name, :class_code, :semester, presence: true
  validates :code, uniqueness: { scope: %i[class_code semester] }

  # Define os discentes matriculados na turma.
  def discentes
    User.joins(:enrollments).where(enrollments: { turma_id: id, role: "discente" })
  end

  # Define os docentes responsáveis pela turma. Retorna apenas o primeiro docente encontrado, caso haja mais de um.
  def docente
    User.joins(:enrollments).where(enrollments: { turma_id: id, role: "docente" }).first
  end

  # Identificação amigável para listagens/seleção
  def nome_completo
    "#{code} - #{name} (#{class_code} - #{semester})"
  end
end
