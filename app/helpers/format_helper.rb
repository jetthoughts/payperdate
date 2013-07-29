module FormatHelper
  def format_date(time)
    time.strftime('%m/%d/%Y') if time
  end
end