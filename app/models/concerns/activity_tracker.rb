module ActivityTracker
  extend ActiveSupport::Concern

  included do
    has_many :activities do
      def track_sign_out
        self.create action:  :sign_out,
                    subject: proxy_association.owner,
                    details: { time: Time.current }
      end

      def track_sign_in(ip = nil)
        self.create action:  :sign_in,
                    subject: proxy_association.owner,
                    details: { time: Time.current, ip: ip }
      end
    end
  end

  def track_avatar_created(avatar)
    activities.create action:  :create,
                      subject: avatar,
                      details: { image_url: avatar.image_url }
  end

  def track_profile_changed(changes = {})
    activities.create action:  :update,
                      subject: self.profile,
                      details: changes
  end

  def track_user_block(target)
    activities.create action:  :block,
                      subject: target,
                      details: { issuer_id: self.id }
  end

  def track_user_unblock(target)
    activities.create action:  :unblock,
                      subject: target,
                      details: { issuer_id: self.id }
  end

  def track_user_delete(issuer = self)
    activities.create action:  :delete,
                      subject: self,
                      details: { issuer_id: issuer.id }
  end

  def track_user_delete_by_admin(admin)
    activities.create action:  :deleted_by_admin,
                      subject: self,
                      details: { admin_id: admin.id }
  end

  def track_user_restore(admin)
    activities.create action:  :restore,
                      subject: self,
                      details: { admin_id: admin.id }
  end

end
