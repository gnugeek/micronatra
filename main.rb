require 'rubygems'
require 'sinatra'
require 'haml'

enable :sessions 
use_in_file_templates!

get '/' do
  auth_required
  haml :index
end
 
get '/login' do
  haml :login
end
 
post '/login' do
  if authenticate(params[:login], params[:password])
    session[:authenticated] = true
    continue
  else
    redirect '/login'
  end
end
 
get '/logout' do
  auth_required
  session[:authenticated] = nil
  redirect '/'
end
 
get '/stylesheets/style.css' do
  header 'Content-Type' => 'text/css; charset=utf-8'
  sass :style
end

private
 
def auth_required
  return session[:authenticated] if session[:authenticated]
  session[:requested] = request.fullpath
  redirect '/login'
end

def continue
  redirect session[:requested] if session[:requested]
  redirect '/'
end

def authenticate(login,password)
  login == 'admin' && password == 'admin'
end

__END__

@@layout
!!!
%html
  %head
    %title App
    %link{:rel=>"stylesheet", :href=>"/stylesheets/style.css", :type => "text/css"}
  %body
    #banner App
    #nav 
      %a{:href=>("/")}= "home"
      %a{:href=>("/logout" )}= "logout"
    #content
      = yield

@@index
#content
  This is the index page.

@@login
#login-form
%form{:method => "post", :action => "/login"}
  .label Login: 
  %input{:id=>"login", :name=>"login", :size=>"30", :type=>"text"}
  .label Password
  %input{:id=>"password", :name=>"password", :size=>30, :type=>"password"}
  .button
  %input{:type=>"submit", :value=>"login"}
  
@@style

#banner
  :height 20px
  :text-align left
  
body
  :font-family arial

  
