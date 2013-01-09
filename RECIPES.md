How to implement roles
----------------------

AbilityList has no explicit support for roles because they're pretty easy to do 
in the plain ol' Ruby way.

``` ruby
class Abilities < AbilityList
  def initialize(user)
    # Assume this returns an array of strings like ['admin', 'editor'].
    roles = user.roles

    # Now simply call the respective methods of each role.
    roles.each { |role| send role }
  end

  def admin
    can :manage, User
    can :manage, Group
  end

  def editor
    can :edit, Article
  end

  def publisher
    can :publish, Article
  end

  def writer
    can :create, Article
  end
end
```

How to integrate with Rails controllers
---------------------------------------

This Rails example raises an error when the logged in user is not allowed of a 
certain permission.

``` ruby
class ArticleController
  before_filter :authorize_viewing

private

  def authorize_viewing
    current_user.authorize! :view, Article
  end
end
```

How to implement user levels
----------------------------

If your `User` model has a numeric field `level`, where more permissions are 
available to users with higher levels, you can implement it like so:

``` ruby
class Abilities < AbilityList
  def initialize(user)
    if user.level > 50
      can :launch, Rocket
      can :command, Army
    end

    if user.level > 30
      can :view_status, Rocket
    end

    if user.level > 1
      can :login, :site
    end
  end
end
```

Defining Rails helpers
----------------------

The `Helpers` module used in Users can be used as Rails helpers too.

``` ruby
module PermissionsHelper
  # Provides `can?` and `cannot?`... as long as you have `#abilities` defined.
  include AbilityList::Helpers

  def abilities
    current_user.try :abilities
  end
end
```

So that you may:

``` erb
<% if can?(:edit, @post) %>
  <a href="#edit">Edit</a>
<% end %>
```
