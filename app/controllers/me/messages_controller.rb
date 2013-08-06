class Me::MessagesController < BaseController

  def index
    @messages = Message.by(current_user)
  end

  def unread
    @messages = Message.received_by(current_user).unread
    render 'index'
  end

  def received
    @messages = Message.received_by(current_user)
    render 'index'
  end

  def sent
    @messages = Message.sent_by(current_user)
    render 'index'
  end

end
