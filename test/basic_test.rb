require File.expand_path('../helper.rb', __FILE__)

module BasicTest
  Video = Class.new(OpenStruct)

  # ---

  class User < OpenStruct
    include AbilityList::Helpers

    def abilities
      @abilities ||= Abilities.new(self)
    end
  end

  # ---

  class Abilities < AbilityList
    def initialize(user)
      # Every can view videos.
      can :view, Video

      # ...except restricted ones.
      cannot :view, Video, &:restricted

      # ...but for those that are restricted, it's okay if the user is old enough.
      can :view, Video do |vid|
        vid.restricted && user.age > 18
      end
    end
  end

  # ---

  describe "Basic tests" do
    it "#can? 1" do
      user  = User.new :age => 22
      video = Video.new :restricted => false

      user.can?(:view, video).must_equal true
    end

    it "#can? 2" do
      user  = User.new :age => 10
      video = Video.new :restricted => true

      user.can?(:view, video).must_equal false
    end

    it "#can? 3" do
      user  = User.new :age => 42
      video = Video.new :restricted => true

      user.can?(:view, video).must_equal true
    end

    it "#cannot?" do
      user  = User.new :age => 10
      video = Video.new :restricted => true

      user.cannot?(:view, video).must_equal true
    end

    it "#authorize!" do
      user  = User.new :age => 10
      video = Video.new :restricted => true

      assert_raises AbilityList::Error do
        user.authorize! :view, video
      end
    end
  end
end
