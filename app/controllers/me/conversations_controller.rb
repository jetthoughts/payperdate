class Me::ConversationsController < ApplicationController

  before_filter :create_conversation, except: :index

  def index
    @conversations = Conversation.by_user(current_user)
  end

  def show
    if @conversation
      render
      @conversation.read_all!
    else
      redirect_to conversations_path, alert: t('.conversation_with_yorself')
    end
  end

  def append
    authorize! :communicate, @user
    message = @conversation.append(message_attributes[:content])
    if message.valid?
      redirect_to conversation_path(@user), notice: t('.sent_ok')
    else
      redirect_to conversation_path(@user), alert: message.errors.full_messages.flatten.first
    end
  end

  private

  def create_conversation
    @user = User.find(params[:id])
    @conversation = Conversation.by_users(current_user, @user)
  end

  def message_attributes
    params.required(:message).permit(:content)
  end

end
