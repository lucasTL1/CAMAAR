require 'csv'

class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
  end

  def import
    file = params[:file]
    return redirect_to users_path, alert: "Nenhum arquivo selecionado" unless file

    CSV.foreach(file.path, headers: true) do |row|
      # Cria o registro e envia o token por e-mail automaticamente
      User.invite!(
        nome: row['nome'],
        email: row['email'],
        matricula: row['matricula'],
        perfil: row['perfil']
      )
    end

    redirect_to users_path, notice: "Usuários importados e convites enviados com sucesso!"
  end
end