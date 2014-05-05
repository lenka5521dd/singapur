class DialogsController < ApplicationController
  before_action :set_dialog, only: [:show, :edit, :update, :destroy]
  before_action :admin_filter, except: [:enter, :create, :exit]

  # GET /dialogs
  # GET /dialogs.json
  def index
    if params[:dialog].present?
      @dialog = Dialog.find(params[:dialog])
      @dialog.update_attributes(no_read: '0')
      @area = Area.where(id: @dialog.url_start.split('/')[1]).first if @dialog.url_start.present?
      @messages = @dialog.messages.desc(:created_at)
      @geo = Geocoder.search @dialog.ip
    end
    @dialogs = Dialog.ne(done: true).desc(:last_message).page(params[:page]).per(15)
  end

  # GET /dialogs/1
  # GET /dialogs/1.json
  def show
    @messages = @dialog.messages
  end

  # GET /dialogs/new
  def new
    @dialog = Dialog.new
  end

  # GET /dialogs/1/edit
  def edit
  end

  def done
    Dialog.where(id: params[:id]).first.update_attributes(done: true)
    Pusher[params[:id]].trigger('done', 'sorry')
    render text: 'заблокирован'
  end

  def insert
    m = Message.find params[:message]
    dialog = Dialog.find params[:dialog]
    last = dialog.messages.parya.last
    @message = Message.new(dialog_id: dialog.id, text: m.text, author: 'admin')
    if @message.save
      m.k += 1
      m.sensors << last.text
      m.save
      render json: {id: params[:dialog], text: @message.text}
    end
  end

  def enter
    unless request.remote_ip.include?('66.249.')
    # unless ['66.249.66','66.249.76','66.249.64', '66.249.67', '66.249.75', '66.249.'].any? { |word| request.remote_ip.include?(word) }
      if params[:on].present?
        @dialog = Dialog.where(id: params[:on]).first || Dialog.create(ip: request.remote_ip, url_start: params[:url])
      else
        @dialog = Dialog.create(ip: request.remote_ip, url_start: params[:url])
      end
      a = @dialog.url_start.split('/')
      unless @dialog.done
        # ParyaEmail.enter(@dialog.id).deliver
        Pusher['admin'].trigger('enter', { on: @dialog.id.to_s, path: params[:path], city: @dialog.city, ip: @dialog.ip, coord: @dialog.coordinates, new: @dialog.new_record? })
      end
      messages = @dialog.messages.ne(author: 'mrBus')
      render json: {on: @dialog.id.to_s, status: 'ok', messages: messages.asc(:created_at).map{|m| {id: m.id.to_s, message: m}} }
      $redis.sadd('online', @dialog.id.to_s)
    else
      render :nothing
    end
  end

  def exit
    $redis.srem('online',  params[:on])
    render text: 'ok'
  end


  # POST /dialogs
  # POST /dialogs.json
  def create
    @dialog = Dialog.new(dialog_params)

    respond_to do |format|
      if @dialog.save
        format.html { redirect_to @dialog, notice: 'Dialog was successfully created.' }
        format.json { render action: 'show', status: :created, location: @dialog }
      else
        format.html { render action: 'new' }
        format.json { render json: @dialog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dialogs/1
  # PATCH/PUT /dialogs/1.json
  def update
    respond_to do |format|
      if @dialog.update(dialog_params)
        format.html { redirect_to @dialog, notice: 'Dialog was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @dialog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dialogs/1
  # DELETE /dialogs/1.json
  def destroy
    @dialog.destroy
    respond_to do |format|
      format.html { redirect_to dialogs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dialog
      @dialog = Dialog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dialog_params
      params.require(:dialog).permit(:ip, :coordinates, :city)
    end

    def admin_filter
      redirect_to root_path unless current_user.try(:admin)
    end
end
