class ValidateImageJob < Struct.new(:photo_id)
  #TODO: move to concerns
  def self.enqueue(*args)
    if Payperdate::Application.config.background_workers_envs.include? Rails.env
      Delayed::Job.enqueue ValidateImageJob.new(*args)
    else
      Thread.new { ValidateImageJob.new(*args).perform }
    end
  end

  def perform
    Photo.find(photo_id).validate_image!
  end

end