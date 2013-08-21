require 'test_helper'

class RankTest < ActiveSupport::TestCase
  fixtures :ranks

  def test_create
    Rank.create! name: 'some name', value: 5
  end

  def test_presence_name_value
    rank = Rank.new
    assert !rank.valid?
  end

  def test_uniqueness_name
    rank = Rank.new name: ranks(:ok).name, value: 5
    assert !rank.valid?
  end

  def test_uniqueness_value
    rank = Rank.new name: 'some name', value: ranks(:ok).value
    assert !rank.valid?
  end

end
