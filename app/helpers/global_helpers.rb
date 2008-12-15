module Merb
  module GlobalHelpers
    # helpers defined here available to all views.
    def left_sidebar_links
      links = []
      if session.authenticated?
        user = session.user
        links << { :url => resource(user), :text => "View my profile" }
        links << { :url => resource(user, :edit), :text => "Edit my profile" }
        links << { :url => url(:user_search), :text => "Search users" }
        links << { :url => url(:logout), :text => "Logout" }
      else
        links << { :url => url(:new_user), :text => "Register"}
      end
      links        
    end
  end
end
