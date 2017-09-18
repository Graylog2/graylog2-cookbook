if defined?(ChefSpec)
  def create_admin_token(token)
    ChefSpec::Matchers::ResourceMatcher.new(:graylog2_admin_token, :create, token)
  end
end
