require File.dirname(__FILE__) + '/spec_helper'

module ErroredRender
  def self.included(base)
    base.class_eval do
      alias_method_chain :render, :error
    end
  end
  
  def render_with_error
    "woo hoo"
    end
end



describe SnsSassFilter do
  
  before :each do
    @stylesheet = Stylesheet.new(:name => 'test')
    @stylesheet.content = file('sample.sass')
  end
  
  
  describe 'where the Sass filter is not set in the Stylesheet' do
  
    it 'should render the content unaltered if the Sass filter is not applied' do
      @stylesheet.filter_id = ''
      @stylesheet.render.should == file('sample.sass')
    end
  
  end
  
  
  
  describe 'where the Sass filter is selected' do
    
    before :each do
      @stylesheet.filter_id ='Sass'
    end
    
    
    it 'should render Sass content into CSS' do
      @stylesheet.render.should == file('sample.css')
    end



    describe 'and Sass raises an error' do
      
      # This spec avoids mock/stubbing Sass and responds to a real error
      # Problem is, we don't have a reliable way to know what that error
      # will be as Radiant may update Sass.
      it 'should rescue a SyntaxError and render that an error occurred' do
        @stylesheet.content = file('bad.sass')
        @stylesheet.render.should =~ /^Syntax Error at line /
      end
      
      # This spec makes sure we actually process the error message and line
      # number -- but we have to simulate Sass to do it.  A bit tightly
      # coupled (but so's our implementation).  Hopefully if Sass changes
      # greatly, the previous specs will catch it.
      it 'should render the error message and line number' do
        syntax_error = Sass::SyntaxError.new('A Message', 25)
        sass_engine = mock('Sass::Engine')
        sass_engine.stub!(:render).and_raise(syntax_error)
        Sass::Engine.stub!(:new).and_return(sass_engine)
        @stylesheet.render.should == "Syntax Error at line 25: A Message"
      end
      
      
      it 'should not rescue other error types' do
        syntax_error = Exception.new
        sass_engine = mock('Sass::Engine')
        sass_engine.stub!(:render).and_raise(syntax_error)
        Sass::Engine.stub!(:new).and_return(sass_engine)
        lambda { @stylesheet.render }.should raise_error
      end
      
    end

  end
  
end

private

  def file(name)
    File.read(File.dirname(__FILE__) + '/samples/' + name)
  end
