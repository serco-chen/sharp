module Helpers
  module Markdown

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
end

