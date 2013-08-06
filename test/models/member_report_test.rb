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
    assert_predicate report, :valid?
  end

  def test_not_valid_when_content_not_owned_by_reported_user
    report = member_reports(:mias_report_on_martins_profile)
    report.content = profiles(:sophias)
    refute_predicate report, :valid?
  end

  def test_not_valid_when_reporting_not_allowed_content
    report = member_reports(:mias_report_on_martins_profile)
    report.content_type = 'AdminUser'
    refute_predicate report, :valid?
  end

end
