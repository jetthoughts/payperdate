class Me::ConversationsController < ApplicationController

  before_filter :create_conversation, except: :index
  before_filter :find_message, only: :remove_from
  after_filter :read_all_messages, only: :show

  def index
    @conversations = Conversation.by_user(current_user)
  end

  def show
    redirect_to conversations_path, alert: t('.conversation_with_yorself') unless @conversation
  end

  private

  def create_conversation
    @user = User.find(params[:id])
    @conversation = Conversation.by_users(current_user, @user)
  end

  def read_all_messages
    @conversation.read_all! if @conversation
  end

end
