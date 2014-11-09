$: << File.expand_path('../', __FILE__)

require 'sinatra'
require 'sinatra/contrib'
require 'lib/sharp.rb'

set :slim, :layout_options => { :views => 'views/layouts' }

class Sharp < Sinatra::Application

  configure :development do
    register Sinatra::Reloader
    # also_reload '/path/to/some/file'
    # dont_reload '/path/to/other/file'
  end

  helpers Helpers::Markdown
  register Sinatra::Contrib

  set :posts, settings.views + '/posts'

  get '/' do
    'Hello world!'
  end

  get '/posts' do
    Dir.chdir settings.posts do
      @posts = Dir.glob("*.{md, markdown, mkd}").map {|filename| filename[/.*(?=\..+)/]}
    end
    slim :'posts/index', layout: :index
  end

  get '/posts/:post' do
    content = File.read("#{settings.posts}/#{params[:post]}.md") rescue nil
    pass unless content
    @content = markdown content
    slim :'posts/post', layout: :index
  end

  not_found do
    404
  end
end
