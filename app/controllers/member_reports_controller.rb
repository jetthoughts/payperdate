class MemberReportsController < BaseController

  def new
    @member_report = reported_user.member_reports.build user: current_user,
                                                        content_id: params[:content_id],
                                                        content_type: params[:content_type]
    @member_report.reported_user = reported_user
  end

  def create
    content = content_from_params member_report_params
    @member_report = reported_user.member_reports.build member_report_params.merge(user: current_user, content: content)
    @member_report.reported_user = reported_user
    if @member_report.save
      redirect_to user_profile_path(reported_user), notice: t(:'member_reports.messages.was_sent')
    else
      render 'new'
    end
  end

  private

  def reported_user
    @reported_user ||= User.find(params[:user_id])
  end

  def content_from_params(content_hash)
    begin
      content_hash[:content_type].classify.constantize.find(content_hash[:content_id])
    rescue
      nil
    end
  end

  def member_report_params
    params.require(:member_report).permit(:message, :content_type, :content_id)
  end

end
