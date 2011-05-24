require 'spec_helper'

describe Confetti::Template::JavaChecks do
  include Confetti::Template::JavaChecks

  describe "#is_java_identifier" do
    describe "should fail when" do
      it "has invalid characters" do
        is_java_identifier("ooo:bu").should be_false
      end

      it "begins with a number" do
        is_java_identifier("12Class").should be_false
      end

      it "should fail wtih an empty string" do
        is_java_identifier('').should be_false
      end
    end

    describe "should succeed when" do
      it "valid characters are passed" do
        is_java_identifier("ClassName").should be_true
      end
    end
  end

  describe "#convert_to_java_identifier" do
    it "should not affect a valid identifier" do
      convert_to_java_identifier("Foo").should == "Foo"
    end

    it "should remove spaces" do
      convert_to_java_identifier("Sample App").should == "SampleApp"
    end

    it "should convert non-space invalid characters to underscores" do
      convert_to_java_identifier("Foo:Bar").should == "Foo_Bar"
    end

    it "should convert an initial digit to an underscore" do
      convert_to_java_identifier("12Foo").should == "_2Foo"
    end
  end

  describe "#is_java_package_id" do
    it "should accept a dot-separated list of lower case java identifiers" do
      is_java_package_id("com.alunny.foo").should be_true
    end

    it "should not accept a dot-terminated string" do
      is_java_package_id("com.alunny.foo.").should be_false
    end

    it "should not accept a dot-first string" do
      is_java_package_id(".com.alunny.foo").should be_false
    end

    it "should not accept a single java identifier" do
      is_java_package_id("a27a4").should be_false
    end

    it "should not accept a package with hypens in there" do
      is_java_package_id("com.makalumedia.rock-am-ring").should be_false
    end
  end

  describe "#convert_to_java_package_id" do
    it "should not affect a valid package id" do
      pkg = "com.alunny.foo"
      convert_to_java_package_id(pkg).should == pkg
    end

    it "should strip out incorrect characters" do
      pkg = "com.makalumedia.rock-am-ring"
      fixed_pkg = "com.makalumedia.rock_am_ring"
      convert_to_java_package_id(pkg).should == fixed_pkg
    end

    it "should strip out leading dots" do
      pkg = ".com.alunny.foo"
      fixed_pkg = "com.alunny.foo"
      convert_to_java_package_id(pkg).should == fixed_pkg
    end

    it "should make sense of terrible identifiers" do
      pkg = "http://BestBusU"
      fixed_pkg = "com.http___BestBusU"
      convert_to_java_package_id(pkg).should == fixed_pkg
    end
  end
end
