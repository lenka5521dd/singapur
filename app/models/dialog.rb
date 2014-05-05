class Dialog
  include Mongoid::Document
  include Mongoid::Timestamps
  field :ip, type: String
  field :coordinates, type: Array
  field :city, type: String
  field :url_start
  field :last_message, type: DateTime
  field :no_read, type: String
  field :done, type: Boolean, default: false
  # field :mail, type: Hash, default: {}
  field :mail, type: String
  has_many :messages



  # before_create :define_location


  def define_location
    self.coordinates = geocoder request.remote_ip
    self.city = geocoder request.remote_ip
    self.save
  end

  def geocoder

  end

  def self.receive_mail(message)
    dialog_id = message.subject[/^Update (\d+)$/, 1]
    if dialog_id.present? && Dialog.exists?(dialog_id)
      Dialog.update(dialog_id, mail: message.body.decoded)
    else
      Dialog.create mail: message.body.decoded
    end
  end


end
