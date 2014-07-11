module Extensions
  module Templates

    def config_option key, value=nil, options={}
      separator = options[:separator] || ' = '
      [key, separator, value.to_s, "\n"].join unless value.nil?
    end

  end
end
