require 'rubygems'
require 'sinatra/base'
require 'haml'

class Micronatra < Sinatra::Base
  
  enable :static, :sessions
  set :Root, File.dirname(__FILE__) 
  use_in_file_templates!

  get '/' do
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
    session[:authenticated] = nil
    redirect '/'
  end

  get '/table' do
    haml :table
  end

  get '/auth' do
    auth_required
    redirect '/'
  end
  
  get '/stylesheets/style.css' do
    response['Content-Type'] = 'text/css; charset=utf-8'
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

end

__END__

@@layout
!!!
%html
  %head
    %title Micronatra
    %link{:rel=>"stylesheet", :href=>"/stylesheets/style.css", :type => "text/css"}
  %body
    #banner 
      Micronatra
    #nav 
      %a{:href=>("/")}= "HOME"
      %a{:href=>("/table")}= "TABLE-TEST"
      %a{:href=>("/auth")}= "AUTH-TEST"
      %a{:href=>("/logout" )}= "LOGOUT"
    #content
      = yield
    #footer
      Powered by Sinatra

@@index
#content
  Micronatra is a small test application written with the Ruby "Sinatra" framework.
  Sinatra is a DSL for quickly creating web-applications in Ruby with minimal effort.
  I find Sinatra to be an elegant implementation of the UNIX design philosophy:
  %blockquote
    "Write programs that do one thing and do it well."
  For more information about Sinatra, please see:
  %ul
    %li 
      The Hat:
      %a{:href=>("http://sinatra.rubyforge.org/")}= "http://sinatra.rubyforge.org/"
    %li
      The Book:
      %a{:href=>("http://sinatra.rubyforge.org/book.html")}= "http://sinatra.rubyforge.org/book.html"
    %li 
      The API:
      %a{:href=>("http://sinatra.rubyforge.org/api/")}= "http://sinatra.rubyforge.org/api/"
    %li 
      The Source:
      %a{:href=>("http://github.com/bmizerany/sinatra/tree/master")}= "http://github.com/bmizerany/sinatra/tree/master"
    %li
      Micronatra Source:
      %a{:href=>("http://github.com/gnugeek/micronatra/tree/master")}= "http://github.com/gnugeek/micronatra/tree/master"


@@login
#login-form
%form{:method => "post", :action => "/login"}
  .label Login: 
  %input{:id=>"login", :name=>"login", :size=>"30", :type=>"text"}
  .label Password
  %input{:id=>"password", :name=>"password", :size=>30, :type=>"password"}
  %p
  .button
    %input{:type=>"submit", :value=>"login"}

#explanation
  This is a very simple authentication test.  The login and password are both "admin"

@@table
%table
  %caption Table
  %thead
    %tr
      %th one
      %th two
      %th three
      %th four
  %tbody
    %tr
      %td 1
      %td 2
      %td 3
      %td 4
    %tr
      %td foo
      %td bar
      %td baz
      %td bat
    %tr
      %td a
      %td b
      %td c
      %td d
  
@@style

a:link
  :color #000
  
body
  :font-family Comic Sans MS
   
#banner
  :text-align left
  :color #fff
  :background #000
  :font-size 18px
  :height 24px
  :padding 2px
  :font-weight bold
  
#content
  :padding 10px 0px

#nav
  :text-align left
  :color #fff
  :background #ccc
  :font-size 14px
  :font-weight bold
  :padding 2px
  
#login-form
  :padding 2px

#footer
  :text-align right
  :color #fff
  :background #000
  :font-size 12px
  :font-weight bold
  :height 15px  
  :padding 2px