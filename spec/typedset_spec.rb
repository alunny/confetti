require "spec_helper"

describe TypedSet do
  it "should fail without a class being passed in" do
    lambda { TypedSet.new "foo" }.should raise_error ArgumentError
  end

  it "should succeed when a class is passed in" do
    lambda { TypedSet.new String }.should_not raise_error
  end

  it "should allow initialization with values" do
    lambda { 
      TypedSet.new(String, "one", "two", "three")
    }.should_not raise_error
  end

  it "should not allow initialization with invalid values" do
    lambda { 
      TypedSet.new(String, "one", [1, "two"], "three")
    }.should raise_error ArgumentError
  end

  describe "when defined with a class" do
    before do
      @new_set = TypedSet.new String
    end

    it "should expose the given class as set_class" do
      @new_set.set_class.should be String
    end

    it "should not allow #add with different classes" do
      lambda { @new_set.add 12 }.should raise_error ArgumentError
    end

    it "should allow #add with the right class" do
      lambda { @new_set.add "string" }.should_not raise_error
    end

    it "should add an object of the right class to the set using #add" do
      @new_set.add "foo"
      @new_set.should include "foo"
    end

    it "should not allow #<< with different classes" do
      lambda { @new_set << 12 }.should raise_error ArgumentError
    end

    it "should allow #<< with the right class" do
      lambda { @new_set << "string" }.should_not raise_error
    end

    it "should add an object of the right class to the set using #<<" do
      @new_set << "foo"
      @new_set.should include "foo"
    end

    it "should not allow #add? with different classes" do
      lambda { @new_set.add? 12 }.should raise_error ArgumentError
    end

    it "should allow #add? with the right class" do
      lambda { @new_set.add? "string" }.should_not raise_error
    end

    it "should add an object of the right class to the set using #<<" do
      @new_set.add? "foo"
      @new_set.should include "foo"
    end
  end
end
