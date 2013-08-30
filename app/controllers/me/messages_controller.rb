class Me::MessagesController < BaseController

  before_filter :find_user_message, only: [:show, :destroy]

  def show
    authorize! :show, @message
    @message.read! if @message.unread?
  end

  def destroy
    authorize! :destroy, @message
    if @message.delete_by(current_user)
      redirect_to messages_path, notice: t(:'messages.messages.was_deleted')
    else
      # FIXME: Brilliant. Reason why wasn't it deleted?
      # TODO: Cover this conditional path by test.
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
    @message = Message.find(params[:id])
  end

end
