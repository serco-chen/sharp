require 'sinatra'
require 'sinatra/contrib'

set :slim, :layout_options => { :views => 'views/layouts' }

class Sharp < Sinatra::Application

  configure :development do
    register Sinatra::Reloader
    # also_reload '/path/to/some/file'
    # dont_reload '/path/to/other/file'
  end

  helpers MarkdownHelpers
  register Sinatra::Contrib

  set :posts, settings.views + '/posts'

  module MarkdownHelpers

    def markdown(content=nil)
      @markdown ||= markdown_engine
      @markdown.render(content)
    end

    private
    def renderer(options={})
      options.merge!({with_toc_data: true, escape_html: true})
      Redcarpet::Render::HTML.new options
    end

    def markdown_engine(renderer=renderer, options={})
      options.merge!({
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        autolink: true
      })
      @markdown = Redcarpet::Markdown.new(renderer, options)
    end
  end

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
