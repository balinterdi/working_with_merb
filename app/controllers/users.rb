class Users < Application
  # provides :xml, :yaml, :js
  before :ensure_authenticated, :exclude => [:new, :create, :show]

  def index
    @users = User.all
    display @users
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
      redirect resource(@user), :message => { :notice => "User was successfully created" }
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
       redirect resource(@user)
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
    #FIXME: watch out, SQL injection is possible, the user directly inputs the q param
    users_with_matching_name = User.all_by_name_portion(params[:q])
    users_with_matching_name.empty? ? nil : users_with_matching_name.collect { |u| u.name }.join("\n")
  end

end # Users
