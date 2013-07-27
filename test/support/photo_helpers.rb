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