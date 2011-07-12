class UsersController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter
  
  before_filter :authenticate, :only => [:index, :edit, :update, :destroy]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy, :index]
  
  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
    @login_url = CASClient::Frameworks::Rails::Filter.login_url(self)
    @username = session[:casfilteruser]   
  end

  def show
    @username = session[:casfilteruser]

    if User.find_by_id(params[:id]).nil?
      deny_access
    elsif User.find_by_id(params[:id]) == User.authenticate_with_UID(@username)
      @user = User.find_by_id(params[:id])
      @meals = @user.meals.paginate(:page => params[:page])
      @foods = Food.search(params[:search])
      @title = @user.name
    else
      deny_access
    end
  end

  def new
    @user = User.new
    @title = "Sign up"
    @login_url = CASClient::Frameworks::Rails::Filter.login_url(self)
    @username = session[:casfilteruser]
    if !User.authenticate_with_UID(@username).nil?  #if the user exists, sign in instead.
      redirect_to signin_path, :notice => "Please sign in."
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome!"
      redirect_to @user
      Pony.mail(:from => 'teamdietumd@gmail.com', :to => @user.email, :subject => 'Welcome to the DIET Tracker!', :html_body => '<h1>Welcome!</h1> <p> Thanks for joining up! </p> <p> You rock! </p>',:body => 'Thanks for joining us! You rock!' ,:via => :smtp, :via_options => {
          :address              => 'smtp.gmail.com',
          :port                 => '587',
          :enable_starttls_auto => true,
          :user_name            => 'teamdietumd@gmail.com',
          :password             => 'Gemstone13',
          :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
          :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
        })
    else
      @title = "Oops"
      #@user.password = ""
      #@user.password_confirmation = ""
      render 'new'
    end
  end
  
  def edit
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end
  
  def deny_access
      redirect_to signin_path, :notice => "Please sign in to access this page."
    end
    
  private

    def authenticate
        deny_access unless signed_in?
      end
      
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
