ActiveAdmin.register MemberReport do
  MemberReport.state_machines[:state].states.each do |state|
    scope state.name, default: state.name == :active
  end

  batch_action :dismiss do |selection|
    authorize! :dismiss, MemberReport
    MemberReport.find(selection).each do |member_report|
      member_report.dismiss!
    end
    redirect_to [:admin, :member_reports]
  end

  member_action :dismiss, method: :put do
    member_report = MemberReport.find(params[:id])
    authorize! :enable, member_report
    member_report.dismiss!
    redirect_to [:admin, :member_reports]
  end

  member_action :block, method: :put do
    member_report = MemberReport.find(params[:id])
    authorize! :block, member_report
    member_report.block_reported_user!
    redirect_to [:admin, :member_reports]
  end

  index title: 'Member reports', download_links: false do
    selectable_column

    column :user do |member_report|
      link_to member_report.reported_user.name, [:admin, member_report.reported_user]
    end

    column :content do |member_report|
      link_to member_report.content.name, [:admin, member_report.content]
    end

    column :message do |member_report|
      render 'admin/member_report/user_message', member_report: member_report
    end

    column :state do |member_report|
      member_report.state
    end

    column :created_at do |member_report|
      l(member_report.created_at, format: :short)
    end

    column 'Actions' do |member_report|
      render 'admin/member_report/state_actions', member_report: member_report
    end
  end

end
