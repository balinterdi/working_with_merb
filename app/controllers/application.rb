class Application < Merb::Controller
  
  def ensure_admin
    if admin_user?
      session.user
    else
      #TODO: Unauthorized would be more appropriate
      # but then user receives error and not
      # the login screen
      # raise Unauthorized
      raise Unauthenticated
    end
  end
  
  def admin_user?
    logged_user_role == "admin"
  end
  
  private
  def logged_user_role
    session.user.nil? ? nil : session.user.role
  end  
  
end