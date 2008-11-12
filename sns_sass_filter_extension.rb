class SnsSassFilterExtension < Radiant::Extension
  version "0.3"
  extension_name "Styles 'n Scripts SASS Filter"
  description "Allows you to create DRY CSS in the Styles 'n Scripts Extension using Hampton Catlin's wonderful Sass library."
  url "http://haml.hamptoncatlin.com"
  
  def activate
    raise "The SnS Sass Filter extension requires the Styles 'n Scripts extension be available" unless defined?(SnsExtension)
    SnsSassFilter
  end
end