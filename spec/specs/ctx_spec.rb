require '../spec_helper'

describe CTX do

  it "Can scope method definitions within a dynamic scope" do

    class ScopeTest
      def scoped_method(num)
        "original context : #{num}"
      end
    end

    class ScopeTest
      scoped_define :bar, :scoped_method do |num|
        "bar context : #{num * 2}"
      end

      scoped_define :foo, :scoped_method do |num|
        "foo context : #{num / 2}"
      end

      scoped_define :scoped_method do |num|
        "anonymous context : #{num + 2}"
      end

    end

    scoped = ScopeTest.new

    current_scope.should be_nil
    scoped.scoped_method(10).should == "original context : 10"

    scope :foo do
      current_scope.should == :foo
      scoped.scoped_method(10).should == "foo context : 5"

      scope(:bar) do
        current_scope.should == :bar
        scoped.scoped_method(10).should == "bar context : 20"
        scope :unknown do
          scoped.scoped_method(10).should == "bar context : 20"
        end
      end

      current_scope.should == :foo

      scoped.scoped_method(10).should == "foo context : 5"

      scope do
        current_scope.should == :anonymous
        scoped.scoped_method(10).should == "anonymous context : 12"
      end
    end

    scoped.scoped_method(10).should == "original context : 10"

    class ::String
      scoped_define :+ do |other|
        "#{self.capitalize} #{other.capitalize}!"
      end
    end

    ("hello" + "world").should_not == "Hello World!"

    scope {
      ("hello" + "world").should == "Hello World!"
    }


  end

end
