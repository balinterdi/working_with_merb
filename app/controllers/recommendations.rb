class Recommendations < Application
  # provides :xml, :yaml, :js

  def index
		find_opts = {}
		find_opts[:user_id] = params[:user_id] unless params[:user_id].nil?
    @recommendations = Recommendation.all(find_opts)
    display @recommendations
  end

  def show(id)
    @recommendation = Recommendation.get(id)
    raise NotFound unless @recommendation
    display @recommendation
  end

  def new
    only_provides :html
    @recommendation = Recommendation.new
    display @recommendation
  end

  def edit(id)
    only_provides :html
    @recommendation = Recommendation.get(id)
    raise NotFound unless @recommendation
    display @recommendation
  end

  def create(recommendation)
    @recommendation = Recommendation.new(recommendation)
    if @recommendation.save
			#TODO: make the @recommendation resource valid by declaring recommendations as resources in the router file
      # redirect resource(@recommendation), :message => {:notice => "Recommendation was successfully created"}
			redirect url(:controller => :recommendations)
    else
      message[:error] = "Recommendation failed to be created"
      render :new
    end
  end

  def update(id, recommendation)
    @recommendation = Recommendation.get(id)
    raise NotFound unless @recommendation
    if @recommendation.update_attributes(recommendation)
       redirect resource(@recommendation)
    else
      display @recommendation, :edit
    end
  end

  def destroy(id)
    @recommendation = Recommendation.get(id)
    raise NotFound unless @recommendation
    if @recommendation.destroy
      redirect resource(:recommendations)
    else
      raise InternalServerError
    end
  end

end # Recommendations
