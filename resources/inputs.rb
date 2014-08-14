actions :create

attribute :input, :kind_of => String

def initialize(*args)
  super
  @action = :create
end
