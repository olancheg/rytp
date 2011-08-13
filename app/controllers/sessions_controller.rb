class SessionsController < ApplicationController
  def create
    reset_session
    # oauth login
    if auth = request.env['omniauth.auth']
      unless @auth = Authentication.find_from_hash(auth)
        # Create a new user or add an auth to existing user, depending on
        # whether there is already a user signed in.
        @auth = Authentication.create_from_hash(auth, current_user)
      end
      # Log the authorizing user in.
      self.current_user = @auth.user
      flash[:success] = t(:'authentication.success')
    end
    redirect_to watch_path(last_poop)
  end

  def destroy
    flash[:notice] = t(:'authentication.logout', :name => current_user)
    reset_session
    self.current_user = nil
    redirect_to watch_path(last_poop)
  end

  def failure
    flash[:error] = t(:'authentication.failure')
    redirect_to watch_path(last_poop)
  end
end
