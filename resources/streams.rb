actions :create

attribute :stream, :kind_of => String
attribute :rules,  :kind_of => String

def initialize(*args)
  super
  @action = :create
end
