module FormatHelper

  def format_date(time)
    time.strftime('%m/%d/%Y')
  end

  def format_date_time(time)
    time.strftime('%m/%d/%Y %H:%M %p')
  end

  def format_time(time)
    time.strftime('%H:%M %p')
  end

end