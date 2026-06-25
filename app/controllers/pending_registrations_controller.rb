# Definição de senha do participante importado via SIGAA. O cadastro só é
# concluído (vira User) quando o participante define a senha pelo link.
class PendingRegistrationsController < ApplicationController
  # GET /users/password/define?token=...
  def edit
    @pending = PendingRegistration.find_by(token: params[:token])
    redirect_to root_path, alert: "Link inválido" if @pending.nil?
  end

  # POST /users/password/define
  def update
    @pending = PendingRegistration.find_by(token: params[:token])
    redirect_to root_path, alert: "Link inválido" and return if @pending.nil?

    senha = params[:senha].to_s

    User.create!(
      email: @pending.email,
      nome: @pending.nome.presence || @pending.email.split("@").first,
      matricula: @pending.matricula.presence || gerar_matricula(@pending),
      perfil: @pending.perfil.presence || "discente",
      password: senha,
      password_confirmation: senha
    )

    @pending.destroy

    redirect_to users_path, notice: "Cadastro concluído com sucesso."
  end

  private

  def gerar_matricula(pending)
    "90#{pending.id.to_s.rjust(7, '0')}"
  end
end
