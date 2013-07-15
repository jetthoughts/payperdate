unless Rails.env.test?
  NudityDetectorService.instance = :nude
end