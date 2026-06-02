class User < ApplicationRecord
  # O devise_invitable cuida do envio do e-mail para definição de senha
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable

  # Regras para impedir o banco de salvar dados vazios ou repetidos
  validates :nome, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :perfil, presence: true, inclusion: { in: %w[docente discente] }
end