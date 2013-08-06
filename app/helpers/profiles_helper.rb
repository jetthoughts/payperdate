require 'selector'

module ProfilesHelper
  include SelectHelper

  def gmap_for(profile)
    t 'tools.gmap.uri', latitude: profile.latitude, longitude: profile.longitude
  end

  # for active admin table views
  def select_row(param, type, options = {})
    row param, options do
      select_title(type, profile.send(param))
    end
  end

  def row_with_profanity(param, options = {})
    profile ||= options[:profile]
    options.delete :profile
    row param, options do
      value = profile.send(param)
      words = Obscenity.offensive(value)
      highlight(value, words)
    end
  end

  def profile_panel(name)
    name = name.to_s
    panel name.humanize, id: name do
      render "admin/profile/#{name}"
    end
  end

  def profile_panels(*names)
    names.each do |name|
      profile_panel name
    end
  end

  def editable_form
    form_for profile, url: admin_profile_path(profile) do |f|
      yield f
    end
  end

  def editable_row(name, options, &block)
    profile ||= options[:profile]
    with ||= options[:with]
    f ||= options[:f]
    type ||= options[:type]
    if with == :profanity
      row_with_profanity name, profile: profile, class: 'profile-inline-edit'
    elsif with == :select
      select_row name, type, class: 'profile-inline-edit'
    elsif with.blank?
      row name, class: 'profile-inline-edit'
    else
      row name, class: 'profile-inline-edit' do
        value = profile.send(name)
        "#{value} #{with.to_s}" unless value.blank?
      end
    end
    row :"#{name}_edit", class: 'profile-hide profile-inline-edit' do
      block.call(f, name, class: 'profile-hide profile-inline-edit')
    end
  end

  def editable_text
    Proc.new { |f, name, options| f.text_field name, options }
  end

  def editable_number(min = nil, max = nil)
    Proc.new do |f, name, options|
      options[:min] ||= min
      options[:max] ||= max
      f.number_field name, options
    end
  end

  def editable_area
    Proc.new do |f, name, options|
      options[:rows] ||= 5
      f.text_area name, options
    end
  end

  def editable_select(type)
    Proc.new { |f, name, options| f.select name, select_options(type), options }
  end

  def editable_checkbox
    Proc.new do |f, name, options|
      f.check_box name, options,'true', 'false'
    end
  end

  def edit_link(anchor = nil)
    span do
      link_to 'Edit', "#{anchor || '#'}", class: 'profile-inline-edit-activate'
    end
  end

  def edit_submit(f)
    row 'Submit', class: 'profile-hide profile-inline-edit' do
      f.submit class: 'button profile-hide profile-inline-edit'
    end
  end
end
