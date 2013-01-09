How to implement roles
----------------------

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
