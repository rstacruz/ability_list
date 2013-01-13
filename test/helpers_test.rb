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
      (!! user.can?(:cook, :spam)).must_equal false
    end

    it '#cannot? fail' do
      (!! user.cannot?(:cook, :spam)).must_equal true
    end

    it '#authorize! fail' do
      assert_raises AbilityList::Error do
        user.authorize! :cook, :spam
      end
    end
  end
end
