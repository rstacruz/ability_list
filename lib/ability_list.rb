class AbilityList
  Error = Class.new(StandardError)

  # Returns a list of rules. These are populated by `can` and `cannot`.
  # (Rules are tuples)
  def rules
    @rules ||= []
  end

  # ---

  # Declares that the owner can perform `verb` on `class`.
  def can(verb, klass=nil, &block)
    rules << [true, verb, get_class(klass), block]
  end

  # Inverse of `can`.
  def cannot(verb, klass=nil, &block)
    rules << [false, verb, get_class(klass), block]
  end

  # ---

  # Checks if the owner can perform `verb` on the given `object` (or class).
  def can?(verb, object=nil)
    rules = rules_for(verb, get_class(object))
    rules.inject(false) do |bool, (sign, _, _, proc)|
      sign ?
        (bool || !proc ||  proc.call(object)) :  # can
        (bool &&  proc && !proc.call(object))    # cannot
    end
  end

  # Inverse of `can?`.
  def cannot?(verb, object=nil)
    ! can?(verb, object)
  end

  # ---

  # Ensures that the owner can perform `verb` on `object/class` -- raises an
  # error otherwise.
  def authorize!(verb, object=nil)
    can?(verb, object) or raise Error.new("Access denied (#{verb})")
  end

  # Inverse of `authorize!`.
  def unauthorize!(verb, object=nil)
    cannot?(verb, object) or raise Error.new("Access denied (#{verb})")
  end

  # ---

  # Returns a subset of `rules` that match the given `verb` and `class`.
  def rules_for(verb, klass)
    rules.select do |(sign, _verb, _klass, block)|
      (_verb  == :manage || _verb  == verb) &&
      (_klass == :all    || _klass == klass)
    end
  end

private

  def get_class(object)
    [NilClass, Symbol, Class].include?(object.class) ? object : object.class
  end
end

# Provides `#can?` and `#cannot?` and other helpers.
# Assumes that you have an `#ability` method defined.
module AbilityList::Helpers
  def can?(*a)
    abilities && abilities.can?(*a)
  end

  def cannot?(*a)
    !abilities || abilities.cannot?(*a)
  end

  def authorize!(*a)
    raise AbilityList::Error.new("No 'ability' defined") unless abilities
    abilities.authorize!(*a)
  end
end

require 'ability_list/version'

