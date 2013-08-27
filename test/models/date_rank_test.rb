require 'test_helper'

class DateRankTest < ActiveSupport::TestCase

  fixtures :users, :users_dates, :ranks

  def test_create
    DateRank.create! user:              users(:john),
                     users_date:        users_dates(:locked_date_john_lily),
                     courtesy_rank:     ranks(:ok),
                     punctuality_rank:  ranks(:ok),
                     authenticity_rank: ranks(:ok)
  end

  def test_ranking_user_not_referenced_by_invitation
    users_date = users_dates(:locked_date_john_lily)
    date_rank  = users_date.date_ranks.build user:              users(:martin),
                                             courtesy_rank:     ranks(:ok),
                                             punctuality_rank:  ranks(:ok),
                                             authenticity_rank: ranks(:ok)
    assert !date_rank.valid?
  end

end
