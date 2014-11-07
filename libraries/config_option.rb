module Extensions
  module Templates

    def config_option key, value=nil, options={}
      escaped_value = value.to_s.tr('"', '\"')
      separator = options[:separator] || ' = '
      [key, separator, escaped_value, "\n"].join unless value.nil?
    end

  end
end
