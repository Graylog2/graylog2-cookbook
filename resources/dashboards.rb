actions :create

attribute :dashboard, :kind_of => String
attribute :widgets,   :kind_of => String

def initialize(*args)
  super
  @action = :create
end
