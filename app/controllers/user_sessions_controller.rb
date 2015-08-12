class UserSessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  respond_to :json
  def create
    if login(params[:email], params[:password])
      if session[:redirect_to_url]
        # redirect_back_or_to(session[:redirect_to_url], notice: "Welcome Back!")
        render :status => 200,
           :json => { :success => true,
                      :info => "Logged in",
                      :user => current_user,
                      :location => session[:redirect_to_url],
                      :notice => "Welcome Back!"
           }

      else
        render :status => 200,
           :json => { :success => true,
                      :info => "Logged in",
                      :user => current_user,
                      :location => '/marketplace',
                      :notice => "Welcome Back!"
           }
        # redirect_back_or_to('/marketplace', notice: "Welcome Back!")
      end
    else
      render :status => 401,
           :json => { :success => false,
                      :info => "Unauthorized",
                      :notice => "Login failed"
            }
      # flash.now[:alert] = 'Login failed'
      # render action: 'new'
    end
  end

  respond_to :json
  def destroy
    logout
    # redirect_to(:root, notice: 'You have logged out. Goodbye!')
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :location => "/",
                      :notice => "You have logged out. Goodbye!"
           }

    
    # redirect_to(:root, notice: 'You have logged out. Goodbye!')
  end

  respond_to :json
  def get_user
    if current_user
      render :status => 200,
             :json => { :success => true,
                        :user => current_user

             }
    else
      render :status => 401,
             :json => { :success => false,
             }
    end
  end
end