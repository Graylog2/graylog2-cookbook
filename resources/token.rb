actions :create

attribute :user, :kind_of => String, :name_attribute => true

def initialize(*args)
  super
  @action = :create
end
