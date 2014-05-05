class Message
  include Mongoid::Document
  include Mongoid::Timestamps
  field :author, type: String
  field :text, type: String
  field :k, type: Integer, default: 0
  field :sensors, type: Array, default: []

  scope :parya, -> {where(author: 'parya')}
  scope :iqs, -> {where(author: 'iq')}

  # default_scope desc(:created_at)

  belongs_to :dialog

  after_create :pusher
  after_update :update_message

  def pusher
    dialog_id = self.dialog_id.to_s
    dialog = self.dialog
    if self.author == "admin"
      Pusher[dialog_id].trigger('message_send', { id: self.id.to_s, message: {text: self.text, author: 'admin'}})
    elsif self.author == "parya"
      Pusher['admin'].trigger('message_send', { id: dialog_id, text: self.text, author: 'parya' }) unless dialog.done
      dialog.no_read = '1'
      # if self.text
    end
    if dialog.present?
      dialog.last_message = Time.now
      dialog.save!
    end
    # message_iq_send(self, dialog) if self.author == "parya"
  end

  def message_iq_send message, dialog
    message_iq = Message.iqs.in(sensors: self.text).first
    if message_iq.present?
      # sleep 7
      message = Message.new(dialog_id: dialog.id, text: message_iq.text, author: 'admin')
      if message.save
        message_iq.k += 1
        message_iq.save
      end

    end
  end

  def update_message
    dialog = self.dialog_id.to_s
    Pusher[dialog].trigger('update_message', { id: self.id.to_s, text: self.text })
  end



end
