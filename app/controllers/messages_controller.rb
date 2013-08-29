class MessagesController < BaseController

  before_filter :load_user
  before_filter :redirect_if_cant_communicate, only: [:new, :create]

  def new
    @message = current_user.messages_sent.build(recipient: @user)
  end

  def create
    @message = current_user.messages_sent.build(messages_attributes.merge(recipient: @user))
    if @message.save
      redirect_to user_profile_path(@user), notice: t('messages.messages.was_sent')
    else
      render 'new'
    end
  end

  private

  def load_user
    @user = User.find params[:user_id]
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
