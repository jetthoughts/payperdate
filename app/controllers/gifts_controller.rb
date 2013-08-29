class GiftsController < BaseController

  before_filter :load_user

  def new
    @gift = @user.gifts.build
  end

  def create
    @gift = current_user.sent_gifts.build gift_attributes.merge(recipient: @user)
    if @gift.save
      redirect_to user_profile_path(@user) , notice: t('gifts.messages.was_sent')
    else
      render action: 'new'
    end
  end

  private

  def gift_attributes
    params.require(:gift).permit(:gift_template_id, :comment, :private)
  end

  def load_user
    @user = User.find params[:user_id]
  end

end
