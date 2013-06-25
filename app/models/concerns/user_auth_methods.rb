module UserAuthMethods
  def failed_login!
    self.failed_sign_in_count +=1
    save!
  end
end