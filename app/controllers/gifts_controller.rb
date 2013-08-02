class GiftsController < BaseController

  def new
    @gift = recipient.gifts.build
  end

  def create
    @gift = recipient.gifts.build gift_attributes.merge(user: current_user)

    if @gift.save
      redirect_to user_profile_path(@gift.recipient) , notice: t('gifts.messages.was_sent')
    else
      render action: 'new'
    end
  end

  private

  def gift_attributes
    params.require(:gift).permit(:gift_template_id, :comment, :private)
  end

  def recipient
    User.find(params[:user_id])
  end

end
