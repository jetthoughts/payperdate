class Me::MessagesController < BaseController

  include ApplicationHelper

  before_filter :find_user_message, only: [:show, :destroy]

  def show
    not_found unless @message
    @message.read! if @message.unread?
  end

  def destroy
    if @message && @message.delete_by(current_user)
      redirect_to messages_path, notice: t(:'messages.messages.was_deleted')
    else
      redirect_to messages_path, alert: t(:'messages.messages.was_not_deleted')
    end
  end

  def index
    @messages = Message.by(current_user)
  end

  def unread
    @messages = Message.received_by(current_user).unread
    render :index
  end

  def received
    @messages = Message.received_by(current_user)
    render :index
  end

  def sent
    @messages = Message.sent_by(current_user)
    render :index
  end

  private

  def find_user_message
    @message = Message.by(current_user).where(id: params[:id]).first
  end

end
