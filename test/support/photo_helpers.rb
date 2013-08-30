module Payperdate::TestHelpers
  def create_tmp_image
    Tempfile.new(%w(example .jpg)).tap { |f| f.puts('stub image file body') }
  end

  def build_upload_for(file)
    ActionDispatch::Http::UploadedFile.new(filename:     'example.jpg',
                                           content_type: 'image/jpeg',
                                           tempfile:     file)
  end
end

module Payperdate::TestExtendedHelpers
  # a bit of magic, 'cause avatars and photos is really one object for db
  def photos_and_avatars_fixtures
    fixtures :photos

    define_method :avatars do |name|
      photos(name)
    end
  end
end
