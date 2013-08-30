class MemberReportsController < BaseController

  before_filter :load_user_and_profile

  def new
    @member_report = @user.member_reports.new(user: current_user, content: @profile)
  end

  def create
    @member_report = @user.member_reports.build(member_report_params.merge(user: current_user, content: @profile))
    if @member_report.save
      redirect_to user_profile_path(@user), notice: t(:'member_reports.messages.was_sent')
    else
      render 'new'
    end
  end

  private

  def load_user_and_profile
    @user    = User.find(params[:user_id])
    @profile = @user.profile
  end

  def member_report_params
    params.require(:member_report).permit(:message)
  end

end
