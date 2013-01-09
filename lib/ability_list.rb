class AbilityList
  Error = Class.new(StandardError)

  # Returns a list of rules. These are populated by `can` and `cannot`.
  # (Rules are tuples)
  def rules
    @rules ||= []
  end

  # ---

  # Declares that the owner can perform `verb` on `class`.
  def can(verb, klass, &block)
    rules << [true, verb, klass, block]
  end

  # Inverse of `can`.
  def cannot(verb, klass, &block)
    rules << [false, verb, klass, block]
  end

  # ---

  # Checks if the owner can perform `verb` on the given `object` (or class).
  def can?(verb, object)
    object_class = object.class == Class ? object : object.class

    rules = rules_for(verb, object_class)
    rules.inject(false) do |bool, (sign, _, _, proc)|
      sign ?
        (bool || !proc ||  proc.call(object)) :  # can
        (bool &&  proc && !proc.call(object))    # cannot
    end
  end

  # Inverse of `can?`.
  def cannot?(verb, object)
    ! can?(verb, object)
  end

  # ---

  # Ensures that the owner can perform `verb` on `object/class` -- raises an
  # error otherwise.
  def authorize!(verb, object)
    can?(verb, object) or raise Error.new("Access denied (#{verb})")
  end

  # Inverse of `authorize!`.
  def unauthorize!(verb, object)
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
end

module AbilityList::Helpers
  def can?(*a)
    ability && ability.can?(*a)
  end

  def cannot?(*a)
    !ability || ability.cannot?(*a)
  end

  def authorize!(*a)
    raise AbilityList::Error.new("No 'ability' defined") unless ability
    ability.authorize!(*a)
  end
end

require 'ability_list/version'

