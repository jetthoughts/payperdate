require 'selector'

module UsersHelper
  include SelectHelper

  def gifts_groups_with_index(group_size, &block)
    current_user.gifts.in_groups_of(group_size, false).each_with_index(&block)
  end
end
