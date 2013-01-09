require File.expand_path('../helper.rb', __FILE__)

module HelpersTest
  Video = Class.new(OpenStruct)

  # ---

  class User < OpenStruct
    include AbilityList::Helpers

    def abilities
    end
  end

  # ---

  describe "Helper tests" do
    let(:user) { User.new }

    it '#can? fail' do
      user.can?(:cook, :spam).should.be.false
    end

    it '#cannot? fail' do
      user.cannot?(:cook, :spam).should.be.true
    end

    it '#authorize! fail' do
      should.raise AbilityList::Error do
        user.authorize! :cook, :spam
      end
    end
  end
end
