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
      user.can?(:make, :fire).should.be.true
    end
    it "#can? 2" do
      user.can?(:make).should.be.true
    end
    it "#can? 3" do
      user.can?(:make, :lasagna).should.be.false
    end
  end
end
