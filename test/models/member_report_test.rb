require 'test_helper'

class MemberReportTest < ActiveSupport::TestCase
  fixtures :users, :profiles, :member_reports

  def test_member_report_create
    report = MemberReport.create! user:          users(:john),
                                  reported_user: users(:mia),
                                  content:       users(:mia).profile,
                                  message:       'She is spammer!!!!'
    assert_equal 'Profile', report.content_type
  end

  def test_valid_when_content_owned_by_reported_user
    report = member_reports(:mias_report_on_martins_profile)
    assert report.valid?
  end

  def test_not_valid_when_content_not_owned_by_reported_user
    report = member_reports(:mias_report_on_martins_profile)
    report.content = profiles(:sophias)
    refute report.valid?
  end

  def test_not_valid_when_reporting_not_allowed_content
    report = member_reports(:mias_report_on_martins_profile)
    report.content = MemberReport.first
    refute report.valid?
  end

  def test_dismiss
    report = member_reports(:mias_report_on_martins_profile)
    assert report.active?
    report.dismiss!
    assert report.dismissed?
  end

  def test_dismiss_should_not_block_any_user
    report = member_reports(:mias_report_on_martins_profile)
    assert report.active?
    report.dismiss!
    assert report.user.active?
    assert report.reported_user.active?
  end

  def test_dismiss_should_not_change_other_reports_to_user
    report = member_reports(:mias_report_on_martins_profile)
    assert report.active?
    assert report.reported_user.member_reports.count > 1
    report.dismiss!
    report.reported_user.member_reports.each do |member_report|
      assert member_report.active? unless member_report == report
    end
  end

  def test_block_reported_user
    report = member_reports(:mias_report_on_martins_profile)
    assert report.active?
    report.block_reported_user!
    assert report.user_blocked?
  end


  def test_block_reported_user_should_block_only_reported_user
    report = member_reports(:mias_report_on_martins_profile)
    assert report.active?
    report.block_reported_user!
    refute report.user.blocked?
    assert report.reported_user.blocked?
  end

  def test_block_reported_user_should_set_to_blocked_all_reports_to_user
    report = member_reports(:mias_report_on_martins_profile)
    assert report.active?
    assert report.reported_user.member_reports.count > 1
    report.block_reported_user!
    report.reported_user.member_reports.each do |member_report|
      assert member_report.user_blocked?
    end
  end

end
