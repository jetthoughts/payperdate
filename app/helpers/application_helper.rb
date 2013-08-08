module ApplicationHelper
  def spinner_tag
    image_tag 'spinner.gif'
  end

  def nav_link_to(link_text, link_path, options = nil)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, class: class_name) do
      link_to link_text, link_path, options
    end
  end

  def link_to_dismiss(title='X')
    link_to title, '#', data: { dismiss: :modal }, class: 'pull-right', 'aria-hidden' => true
  end

  def invitation_link_title
    res = t('invitations.links.invitations')
    active_count = current_user.active_invitations.count
    if active_count > 0
      res  += " (#{active_count})"
    end
    res
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

end
