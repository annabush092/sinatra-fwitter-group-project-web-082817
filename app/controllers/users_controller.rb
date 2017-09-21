class UsersController < ApplicationController

  get "/users/:slug" do
    @user = User.all.find do |user|
      user.slug == params[:slug]
    end
    erb :'users/show'
  end

end
