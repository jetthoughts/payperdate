class Me::ConversationsController < ApplicationController

  before_filter :create_conversation, except: :index
  after_filter :read_all_messages, only: :show

  def index
    @conversations = Conversation.by_user(current_user)
  end

  def show
    redirect_to conversations_path, alert: t('.conversation_with_yorself') unless @conversation
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

  def read_all_messages
    @conversation.read_all! if @conversation
  end

  def message_attributes
    params.required(:message).permit(:content)
  end

end
