AbilityList
===========

Define the list of abilities a user has.

``` ruby
class MyAbilities < AbilityList
  def initialize(user)
    can    :view, Video
    cannot :view, Video, &:restricted
  end
end
```

Then hook it to user.

``` ruby
class User < OpenStruct
  include AbilityList::Owner

  def ability
    @ability ||= MyAbilities.new(self)
  end
end
```

Now you may use `can?`:

``` ruby
user = User.new
user.can?(:view, Video)
user.can?(:view, Video.find(20))
```

### Raising errors

Or you can use `authorize!`, which is exactly like `can?` except it raises
a `AbilityList::Error` exception. Perfect for controllers.

``` ruby
user.authorize! :view, Video.find(20)
```

### Custom criteria

You can pass a block to `can` for custom criteria:

``` ruby
can :view, Video do |video|
  !video.restricted? or user.age > 18
end
```

Limitations
-----------

 * No integration with controllers.

 * No explicit provisions for roles.
 
See RECIPES.md on how to do these things.

Acknowledgements
----------------

Heavily inspired by [cancan](https://github.com/ryanb/cancan).
