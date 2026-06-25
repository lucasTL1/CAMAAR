require "csv"

# Página de resultados de um formulário e download em CSV, identificado pelo
# slug do título (download_results_csv).
class ResultadosController < ApplicationController
  # GET /resultados/:slug
  def show
    @formulario = encontrar_formulario(params[:slug])
    @slug = params[:slug]
    render plain: "Formulário não encontrado", status: :not_found if @formulario.nil?
  end

  # GET /resultados/:slug/download
  def download
    formulario = encontrar_formulario(params[:slug])

    if formulario.nil?
      render plain: "Formulário não encontrado", status: :not_found and return
    end

    if formulario.respostas.empty?
      render plain: "Não há respostas para exportar" and return
    end

    send_data gerar_csv(formulario),
      filename: "#{nome_arquivo(formulario.titulo)}.csv",
      type: "text/csv"
  end

  private

  def encontrar_formulario(slug)
    Formulario.includes(:respostas).find { |f| slugify(f.titulo) == slug }
  end

  # Mesmo cálculo de slug usado nos cenários (acentos são removidos).
  def slugify(titulo)
    titulo.downcase.tr(" .", "__").gsub(/[^a-z0-9_]/, "")
  end

  # Nome do arquivo transliterado para ASCII (mantém "avaliacao", não "avaliao").
  def nome_arquivo(titulo)
    ActiveSupport::Inflector.transliterate(titulo).downcase.gsub(/[^a-z0-9]+/, "_").gsub(/\A_|_\z/, "")
  end

  def gerar_csv(formulario)
    CSV.generate do |csv|
      csv << [ "Pergunta", "Resposta" ]
      formulario.questions.each do |question|
        formulario.respostas_da(question).each do |resposta|
          csv << [ question.enunciado, resposta.valor ]
        end
      end
    end
  end
end
