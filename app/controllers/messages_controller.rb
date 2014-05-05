class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :admin_filter, except: [:create, :updated]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.iqs.desc(:created_at).page(params[:page]).per(35)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    if params[:d].present?
      @message = Message.new(dialog_id: params[:d], text: params[:m], author: params[:a])
      render text: @message.id.to_s if @message.save
    else
      @message = Message.new(message_params)
      redirect_to messages_path if @message.save
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      url = '/dialogs?dialog=' + @message.dialog_id
      if @message.update(message_params)
        format.html { redirect_to url, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def updated
    Pusher['admin'].trigger('updated', { id: params[:id] })
    dialog = Message.find(params[:id]).dialog
    dialog.messages.create(text: 'Успешно обновлено', author: 'mrBus')
    render text: 'ok'
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:author, :text, :k)
    end

    def admin_filter
      render text: 'fucking hacker' unless current_user.try(:admin)
    end
end
