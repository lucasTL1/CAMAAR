##
# Define a model para representar a matrícula de um usuário em uma turma, incluindo o papel (docente ou discente) do usuário na turma.
# == Schema:
#  * id: integer, primary key
#  * user_id: integer, foreign key para o usuário
#  * turma_id: integer, foreign key para a turma
#  * role: string, papel do usuário na turma (docente ou discente)
class Enrollment < ApplicationRecord
  # Define os papéis possíveis para a matrícula, que são "docente" e "discente".
  ROLES = %w[docente discente].freeze

  belongs_to :user
  belongs_to :turma

  validates :role, inclusion: { in: ROLES }
  validates :user_id, uniqueness: { scope: :turma_id }

  scope :discentes, -> { where(role: "discente") }
  scope :docentes,  -> { where(role: "docente") }
end
