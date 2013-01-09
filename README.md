AbilityList
===========

Simple permissions system as plain old Ruby objects. No fancy integration with 
ORMs or frameworks.

All of this is just a single Ruby file with less than 50 lines of significant 
code. [Read it now][ability_list.rb].

Usage
-----

### Defining abilities

Define the list of abilities a user has.

``` ruby
class MyAbilities < AbilityList
  def initialize(user)
    can    :view, Video
    cannot :upload, Video
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

### Checking for abilities

Now you may use `can?`:

``` ruby
user = User.new
user.can?(:view, Video)
user.can?(:view, Video.find(20))
```

The inverse `cannot?` is also available.

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

You can even use Ruby's `&:sym` syntax:

``` ruby
cannot :edit, Article, &:published?

# Equivalent to cannot(:edit, Article) { |article| article.published? }
```

### Object types

The method `can` always accepts at least 2 arguments: a *verb* and an *object*.

You can define your permissions by passing a class as the object:

``` ruby
can :view, Video
```

which makes it possible to check for instances or classes:

``` ruby
user.can?(:view, Video)                 #-> passing a class
user.can?(:view, Video.find(1008))      #-> passing an instance
```

But this doesn't have to be classes. Just pass anything else, like a symbol:

``` ruby
can :login, :mobile_site

# user.can?(:login, :mobile_site)
```

### Overriding criteria

Criteria are evaluated on a top-down basis, and the ones at the bottom will 
override the ones on top. For example:

``` ruby
# Everyone can edit comments.
can :edit, Comment

# ...but unconfirmed users can't edit their comments.
if user.unconfirmed?
  cannot :edit, Comment
end

# ...but if the comments are really new, they can be edited, even if the user
# hasn't confirmed.
can :edit, Comment { |c| c.created_at < 3.minutes.ago }
```

Examples
--------

See [RECIPES.md] for more examples.

Limitations
-----------

 * No integration with controllers.

 * No explicit provisions for roles.
 
See [RECIPES.md] on how to do these things.

Acknowledgements
----------------

Heavily inspired by [cancan](https://github.com/ryanb/cancan).

[ability_list.rb]:https://github.com/rstacruz/ability_list/blob/master/lib/ability_list.rb
[RECIPES.md]:https://github.com/rstacruz/ability_list/blob/master/RECIPES.md
