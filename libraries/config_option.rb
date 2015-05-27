module Extensions
  module Templates
    def config_option(key, value = nil, options = {})
      escaped_value = value.to_s.tr('"', '\"')
      separator     = options[:separator] || ' = '
      enclose       = options[:enclose] || ''
      [key, separator, enclose, escaped_value, enclose, "\n"].join unless value.nil?
    end
  end
end

# load template extensions
Erubis::Context.send(:include, Extensions::Templates)
