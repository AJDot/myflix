class AdminsController < UsersController
  before_action :require_user
  before_action :require_admin

  def require_admin
    return if current_user.admin?
    flash[:danger] = 'You do not have access to that area.'
    redirect_to root_path
  end
end
