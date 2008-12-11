class Users < Application
  # provides :xml, :yaml, :js
  # before :ensure_authenticated, :exclude => [:index, :new, :create, :show, :search]
  before :ensure_authenticated, :only => [:edit, :update, :destroy]
  
  def index
    @users = User.all_by_name_portion(params[:user][:name]) if params[:user]
    render :index
  end

  def show(id)
    @user = User.get(id)
    raise NotFound unless @user
    display @user
  end

  def new
    only_provides :html
    @user = User.new
    display @user
  end

  def edit(id)
    only_provides :html
    @user = User.get(id)
    raise NotFound unless @user
    display @user
  end

  def create(user)
    @user = User.new(user)
    if @user.save
      redirect resource(@user), :message => { :notice => "User was successfully created." }
			# redirect resource(:users), :message => {:notice => "User was successfully created"}
    else
      message[:error] = "User failed to be created"
      render :new
    end
  end

  def update(id, user)
    @user = User.get(id)
    raise NotFound unless @user
    if @user.update_attributes(user)
      redirect url(:edit_user, :id => id), 
        :message => { :notice => "User was successfully updated." }
    else
      display @user, :edit
    end
  end

  def destroy(id)
    @user = User.get(id)
    raise NotFound unless @user
    if @user.destroy
      redirect url(:home)
    else
      raise InternalServerError
    end
  end
  
  def user_name_search
    # SQL injection is in theory possible, the user directly inputs the q param
    # but it seems that datamapper generated queries escape quotes to prevent that.
    users_with_matching_name = User.all_by_name_portion(params[:q])
    users_with_matching_name.empty? ? nil : users_with_matching_name.collect { |u| u.name }.join("\n")
  end

end # Users
