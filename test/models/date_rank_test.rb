require 'test_helper'

class DateRankTest < ActiveSupport::TestCase

  fixtures :users, :invitations, :ranks

  def test_create
    DateRank.create! user:              users(:john),
                     invitation:        invitations(:john_lily_locked_yet),
                     courtesy_rank:     ranks(:ok),
                     punctuality_rank:  ranks(:ok),
                     authenticity_rank: ranks(:ok)
  end

  def test_ranking_unaccepted_invitations
    invitation = invitations(:martin_mia_pending)
    date_rank  = invitation.date_ranks.build user:              invitation.invited_user,
                                             courtesy_rank:     ranks(:ok),
                                             punctuality_rank:  ranks(:ok),
                                             authenticity_rank: ranks(:ok)
    assert invitation.pending?
    assert !date_rank.valid?
  end

  def test_ranking_user_not_referenced_by_invitation
    invitation = invitations(:john_lily_locked_yet)
    date_rank  = invitation.date_ranks.build user:              users(:martin),
                                             courtesy_rank:     ranks(:ok),
                                             punctuality_rank:  ranks(:ok),
                                             authenticity_rank: ranks(:ok)
    assert invitation.accepted?
    assert !date_rank.valid?
  end

end
