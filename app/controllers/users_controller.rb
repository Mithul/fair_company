class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => [:show, :apply, :apply_company]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def apply
    @companies = Company.all
  end

  def apply_company
    @company = Company.find params[:company_id]
    current_user.company = @company
    current_user.save
    current_user.add_role :applied
    flash[:notice] = "Sent request to company for approval"
    redirect_to root_path
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def secure_params
    params.require(:user).permit(:role)
  end

end
