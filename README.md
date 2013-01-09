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

Or you can use `authorize!`, which is exactly like `can?` except it htrows 
exceptions:

``` ruby
user.authorize! :view, Video.find(20)
```

