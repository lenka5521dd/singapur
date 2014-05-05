class IncomingController < ApplicationController
  require 'mail'
  skip_before_filter :verify_authenticity_token
  def event
    dialog = Dialog.where(id: params['headers']['Subject']).first
    if dialog.present?
      dialog.messages.create(author: 'admin', text: params['html']) 
      Rails.logger.log Logger::INFO, params
      render text: 'success', status: 200 # a status of 404 would reject the mail
    end
  end
end
