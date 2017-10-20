class ClubsController < ApplicationController

  def index
    @clubs = Club.all
  end

  def show
    ensure_login
    ensure_role

    @club = Club.find(params[:id])
    render :show
  end

  def new
    ensure_login
    @club = Club.new
  end

  def create
    ensure_login
    @club = Club.new(
      name: params[:club][:name],
      description: params[:club][:description],
      user: current_user
    )

    if @club.save
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :new
    end
  end

  def edit
    @club = Club.find(params[:id])
    ensure_ownership
  end

  def update
    @club = Club.find(params[:id])
    ensure_ownership

    if @club && @club.update(name: params[:club][:name], description: params[:club][:description], user: current_user)
      redirect_to root_path
    else
      flash.now[:alert] = @club.errors.full_messages
      render :edit
    end
  end

  private

  def ensure_ownership #checks that the user id is under the club table as a foreign key aka the owner
    if !session[:user_id] || @club.user_id != current_user.id
      redirect_to root_path
    end
  end

  def ensure_role #if logged in and your role is allowed
    unless current_user && User.allowed_roles.include?(current_user.role)
      flash[:alert] = ["#{current_user.role} is not authorized!"]
      redirect_to root_path
    end
  end

  def ensure_login
    if !current_user
      flash[:alert] = ["Must be logged in"]
      redirect_to new_session_path
    end

  end

end
