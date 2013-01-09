class AbilityList
  Error = Class.new(StandardError)

  # Returns a list of rules.
  # (Rules are tuples)
  def rules
    @rules ||= []
  end

  # Checks if the owner can perform `verb` on the given `object/class`.
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

  # Ensures that the owner can perform `verb` on `object/class` -- raises an
  # error otherwise.
  def authorize!(verb, object)
    can?(verb, object) or raise Error.new("Access denied (#{verb})")
  end

  # Inverse of `authorize!`.
  def deny!(verb, object)
    cannot?(verb, object) or raise Error.new("Access denied (#{verb})")
  end

  # Declares that the owner can perform `verb` on `class`.
  def can(verb, klass, &block)
    rules << [true, verb, klass, block]
  end

  # Inverse of `can`.
  def cannot(verb, klass, &block)
    rules << [false, verb, klass, block]
  end

  # Returns ACL rules that matches given `verb` and `class`.
  def rules_for(verb, klass)
    rules.select do |(sign, _verb, _klass, block)|
      (_verb  == :manage || _verb  == verb) &&
      (_klass == :all    || _klass == klass)
    end
  end
end

module AbilityList::Owner
  def can?(*a)       ability.can?(*a); end
  def cannot?(*a)    ability.cannot?(*a); end
  def authorize!(*a) ability.authorize!(*a); end
  def deny!(*a)      ability.deny!(*a); end
end

require 'ability_list/version'

