class MessagesController < BaseController

  before_filter :load_user

  def new
    if can? :communicate, @user
      @message = current_user.messages_sent.build(recipient: @user)
    else
      redirect_to user_profile_path(@user), alert: t('messages.messages.can_not_send_to_this_user')
    end
  end

  def create
    unless can? :communicate, @user
      return redirect_to user_profile_path(@user), alert: t('messages.messages.can_not_send_to_this_user')
    end
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

  def messages_attributes
    params.require(:message).permit(:content)
  end

end
