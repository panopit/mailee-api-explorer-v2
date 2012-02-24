#coding: utf-8
class ExplorerController < ApplicationController
  def index
  end

  def return
    render text: MaileeAPI.new(params).retrieve
  rescue RestClient::ResourceNotFound => e
    render text: "Recurso não encontrado. Veifique o ID."
  rescue RestClient::UnprocessableEntity => e
    render text: "Não foi posível realizar a operação. Veifique os dados preenchidos."
  rescue RestClient::Found => e
    render text: "Encontrado"
  rescue RestClient::LengthRequired => e
    render text: "Erro 411 - LengthRequired"
  rescue RestClient::InternalServerError => e
    render text: "Erro no Mailee (500)"
  end
end
