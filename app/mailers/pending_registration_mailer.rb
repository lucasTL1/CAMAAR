# Envia ao participante importado do SIGAA o link para definição de senha.
class PendingRegistrationMailer < ApplicationMailer
  def setup_password(pending_registration)
    @pending = pending_registration
    @link = "/users/password/define?token=#{@pending.token}"
    mail(to: @pending.email, subject: "Defina sua senha de acesso ao CAMAAR")
  end
end
