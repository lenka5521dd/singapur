# coding: utf-8
class ExportController < ApplicationController
  before_filter :add_xframe, only: :chat
  layout 'external', only: :chat

  def robots
  end

  def sitemaps
    @areas = Area.all
  end

  def sitemap
    @area = Area.find params[:area]
    @pages = Page.all
  end

  def chat
  end

  def add_xframe
    headers['X-Frame-Options'] = 'GOFORIT'
  end

  def blogger
    @areas = Area.all
  end

end
