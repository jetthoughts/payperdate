require 'test_helper'

class MassMailerTest < ActiveSupport::TestCase
  fixtures :users, :profiles

  def test_filtered_users

    mailer = MassMailer.new
    
    assert_equal mailer.send(:filtered_users).load.size, 9

    mailer = MassMailer.new
    mailer.sex << 'F'

    assert_equal mailer.send(:filtered_users).load.size, 3

    mailer = MassMailer.new
    mailer.sex << 'M'

    assert_equal mailer.send(:filtered_users).load.size, 2

    mailer = MassMailer.new
    mailer.birthdate_start = 20
    mailer.birthdate_start = 30

    assert_equal mailer.send(:filtered_users).load.size, 6

    mailer = MassMailer.new
    mailer.birthdate_start = 25

    assert_equal mailer.send(:filtered_users).load.size, 8

    mailer = MassMailer.new
    mailer.birthdate_end = 30

    assert_equal mailer.send(:filtered_users).load.size, 7

    mailer = MassMailer.new
    mailer.birthdate_end = 30

    assert_equal mailer.send(:filtered_users).load.size, 7
  end

end
