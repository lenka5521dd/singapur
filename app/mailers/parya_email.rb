class ParyaEmail < ActionMailer::Base
  default from: "42b027d2001e4bb24cf5@cloudmailin.net"
  def enter(id)
    @dialog = Dialog.find id
    @id = id
    mail(to: '1000xxxtest@gmail.com', subject: @id)
  end
end
