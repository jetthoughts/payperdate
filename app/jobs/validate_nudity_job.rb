class ValidateNudityJob < Struct.new(:photo_id)
  def self.create_delayed_job(*args)
    if Payperdate::Application.config.background_workers_envs.include? Rails.env
      Delayed::Job.enqueue ValidateNudityJob.new(*args)
    else
      ValidateNudityJob.new(*args).perform
    end
  end

  def perform
    Photo.find(photo_id).validate_nudity!
  end
end