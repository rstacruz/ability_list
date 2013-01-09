AbilityList
===========

Simple permissions system as plain old Ruby objects. No fancy integration with 
ORMs or frameworks.

All of this is just a single Ruby file with less than 50 lines of significant 
code. [Read it now][ability_list.rb].

## Defining abilities

Define the list of abilities a user has by subclassing `AbilityList`.

Each ability is comprised of a **verb** (required) and an **object** (optional).
A *verb* is any symbol, while the *object* can be a symbol or a class.

``` ruby
class Abilities < AbilityList
  def initialize(user)
    can :view, Video

    if user.admin?
      can :delete, Video
      can :upload, Video
    end

    can :login

    can :view, :admin
  end
end
```

Then hook it to user by defining an `abilities` method.

``` ruby
class User < OpenStruct
  include AbilityList::Helpers

  def abilities
    @abilities ||= Abilities.new(self)
  end
end
```

## Checking for abilities

Now you may use `can?`:

``` ruby
user = User.new
user.can?(:view, Video)
user.can?(:view, Video.find(20))

user.can?(:login)
user.can?(:view, :admin)
```

The inverse `cannot?` is also available.

## Raising errors

Or you can use `authorize!`, which is exactly like `can?` except it raises
an `AbilityList::Error` exception. Perfect for controllers.

``` ruby
user.authorize! :view, Video.find(20)
```

## Custom criteria

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

## Object types

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

## Overriding criteria

Criteria are evaluated on a top-down basis, and the ones at the bottom will 
override the ones on top.

The method `cannot` is provided to make exceptions to rules.

For example:

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

## The `:manage` keyword

You can use `:manage` as the verb to allow any verb.

``` ruby
can :manage, Group
```

This allows the user to do anything to `Group` its instances.

``` ruby
user.can?(:delete, Group)       #=> true
user.can?(:create, Group)       #=> true
user.can?(:eviscerate, Group)   #=> true
```

## The `:all` keyword

You can use `:all` as the object for any permission. This allows a verb to work 
on anything.

Don't know why you'll want this, but cancan has it, so:

``` ruby
can :delete, :all
```

So you can:

``` ruby
user.can?(:delete, Video)     #=> true
user.can?(:delete, Article)   #=> true
user.can?(:delete, Recipe)    #=> true
```

More examples
-------------

See [RECIPES.md] for some practical examples.

Limitations
-----------

AbilityList aims to be extremely lean, and to be as framework- and ORM-agnostic 
as possible. As such, it doesn't:

 * No explicit integration with Rails controllers.

 * No explicit integration with ActiveRecord (or any other ORM).

 * No explicit provisions for roles.
 
See [RECIPES.md] on how to do these things.

Acknowledgements
----------------

Heavily inspired by [cancan]. AbilityList is generally a stripped-down version 
of cancan with a lot less features (see    Limitations) above.

(c) 2013 MIT License.

[cancan]: https://github.com/ryanb/cancan
[RECIPES.md]: https://github.com/rstacruz/ability_list/blob/master/RECIPES.md
[ability_list.rb]:https://github.com/rstacruz/ability_list/blob/master/lib/ability_list.rb
