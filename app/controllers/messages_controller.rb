class MessagesController < BaseController

  before_filter :load_user
  before_filter :redirect_if_cant_communicate, only: [:new, :create]

  def new
    @message = current_user.messages_sent.build(recipient: @user)
  end

  def create
    @message = current_user.messages_sent.build(messages_attributes.merge(recipient: @user))
    if @message.save
      if request.xhr?
        render partial: 'me/conversations/message', locals: { message: @message }
      else
        redirect_to user_profile_path(@user), notice: t('messages.messages.was_sent')
      end
    else
      render request.xhr? ? { nothing: true } : 'new'
    end
  end

  private

  def load_user
    @user = User.find params[:user_id]
    @conversation = Conversation.by_users(current_user, @user)
  end

  def redirect_if_cant_communicate
    unless can? :communicate, @user
      redirect_to user_profile_path(@user), alert: t('messages.messages.can_not_send_to_this_user')
    end
  end

  def messages_attributes
    params.require(:message).permit(:content)
  end

end
