class UsersController < ApplicationController
  before_action :authorize_user, except: [:new, :create]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to games_path, notice: "Account created successfully"
    else
      render action: "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render action: "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  def authorize_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to games_path, notice: "You are not allowed to view that page."
    end
  end
end
