class WikisController < ApplicationController 
  before_action :authenticate_user!
  
  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new(wiki_params)
    authorize @wiki
    @wiki.user = current_user

    if @wiki.save
      flash[:notice] = 'Post was saved.'
      redirect_to [@wiki]
    else
      flash.now[:alert] = 'There was an error saving the post.
       Please try again.'
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    @wiki.assign_attributes(wiki_params)
    
    if @wiki.save
      flash[:notice] = 'Post was updated.'
      redirect_to [@wiki]
    else
      flash.now[:alert] = 'There was an error saving the post. 
      Please try again.'
      render :edit
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    @wiki.destroy
    flash[:notice] = "\'#{@wiki.title}\' was deleted successfully."
    redirect_to :wikis
  end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
