require File.expand_path('../helper.rb', __FILE__)

module NilTest
  class User < OpenStruct
    include AbilityList::Helpers

    def abilities
      @abilities ||= Abilities.new(self)
    end
  end

  # ---

  class Abilities < AbilityList
    def initialize(user)
      can :make, :fire
      can :make
    end
  end

  # ---

  describe "Nil tests" do
    let(:user) { User.new }

    it "#can? 1" do
      user.can?(:make, :fire).must_equal true
    end
    it "#can? 2" do
      user.can?(:make).must_equal true
    end
    it "#can? 3" do
      user.can?(:make, :lasagna).must_equal false
    end
  end
end
