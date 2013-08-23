class MassMailer

  include AttrAccessors
  include ActiveModel::Validations
  include ActiveModel::Conversion

  extend ActiveModel::Naming

  attr_accessor :sex, :subject, :text, :test_profile_name, :test_email_address, :send_test_email, :status, :activity_more_than

  integer_attr_accessor :birthdate_start, :birthdate_end
  boolean_attr_accessor :reviewed, :confirmed, :have_photo, :send_as_html

  attr_reader   :errors

  validates :birthdate_start, inclusion: { in: 18..100, allow_blank: true }
  validates :birthdate_end,   inclusion: { in: 18..100, allow_blank: true }
  validates :reviewed,        inclusion: { in: [true,false]  , allow_nil: true }
  validates :confirmed,       inclusion: { in: [true,false]  , allow_nil: true }
  validates :have_photo,      inclusion: { in: [true,false]  , allow_nil: true }

  validates :activity_more_than, numericality: true, allow_blank: true

  validates :subject, presence: true, length: { minimum: 3 }
  validates :text,    presence: true, length: { minimum: 3 }


  def initialize(attributes = {})
    self.sex = []
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    self.sex = self.sex.reject { |i| i.blank? }
    @errors = ActiveModel::Errors.new(self)
  end

  def send_messages
    return false unless valid?
    begin
      response = Mandrill::API.new.messages.send message if users_for_send.any? && !Rails.env.test?
    rescue Exception => e
      errors.add :base, e.message

      return false
    end

    true
  end

  def persisted?
    false
  end

  def self.add_subscribe(email)
    Mandrill::API.new.rejects.delete email unless Rails.env.test?
  end

  def self.remove_subscribe(email)
    Mandrill::API.new.rejects.add email unless Rails.env.test?
  end

  private

  def processed_message
    text.gsub("*|UNSUB|*", "*|UNSUB:#{Rails.application.routes.url_helpers.unsubscribe_url(host: Settings.url_with_port)}|*")
  end

  def message
    message              = {}
    message[:subject]    = subject
    message[:text]       = processed_message
    message[:html]       = processed_message if send_as_html
    message[:from_name]  = Settings.mass_mailing.from_name
    message[:from_email] = Settings.mass_mailing.from_email
    message[:to]         = users_for_send
    message[:merge]      = true
    message
  end

  def users_for_send
    send_test_email ?
      [{email: test_email_address, name: test_profile_name}] :
      filtered_users.map { |u| { email: u.email, name: u.name} }
  end

  def filtered_users
    return @users if @users
    @users = User.subscribed

    @users = @users.by_age_ranging(self.birthdate_start, self.birthdate_end)

    @users = @users.by_sex(self.sex) if self.sex.any?

    @users = @users.reviewed         if self.reviewed
    @users = @users.not_reviewed     if self.reviewed  == false

    @users = @users.confirmed        if self.confirmed
    @users = @users.not_confirmed    if self.confirmed == false

    @users = @users.have_avatar      if self.have_photo
    @users = @users.not_have_avatar  if self.have_photo == false

    @users = @users.activity_more_than(self.activity_more_than) if self.activity_more_than

    @users
  end
end
