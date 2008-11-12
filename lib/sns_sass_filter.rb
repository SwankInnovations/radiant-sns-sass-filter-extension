require 'sass'

class SnsSassFilter < StylesheetFilter
  filter_name 'Sass'
  
  def initialize
    # you can add Sass options in here to control your filter output
    # just make sure you know the consequences of doing so (including
    # that you may need to update all your stylesheets to yield a new
    # LAST-MODIFIED date from the cache.
    @sass_options = {}
  end


  def filter(text)
    begin
      Sass::Engine.new(text, @sass_options).render
    rescue Sass::SyntaxError
      "Syntax Error at line #{$!.sass_line}: " + $!.to_s
    end
  end
end