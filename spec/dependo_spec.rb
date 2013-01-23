require "spec_helper"

describe Dependo::Registry do
    before :each do
        Dependo::Registry.clear
    end

    it "cannot be instantiated" do
        expect { Dependo::Registry.new }.to raise_error("Cannot instantiate Dependo::Registry")
    end

    context "clear" do
        it "when a field is set and then cleared" do
            Dependo::Registry[:thing] = "my thing"
            Dependo::Registry[:thing].should == "my thing"
            Dependo::Registry.clear
            Dependo::Registry[:thing].should == nil
        end
    end

    context "has_key?" do
        it "when a key is registered" do
            Dependo::Registry[:thing] = "thing"
            Dependo::Registry.has_key?(:thing).should == true
        end

        it "when a key is not registered" do
            Dependo::Registry.has_key?(:thing).should == false
        end
    end

    context "include" do
        class TestInclude
            include Dependo::Mixin
            attr_reader :my_reader
            attr_writer :my_writer
            attr_accessor :my_accessor

            def initialize
                @my_reader = "my reader"
                @my_writer = "my writer"
                @my_accessor = "my accessor"
            end

            def my_method
                "my method"
            end

            def self.my_class_method
                "my class method"
            end
        end

        it "when a field is registered before instantiation" do
            Dependo::Registry[:thing] = "this thing"
            obj = TestInclude.new
            obj.thing.should == "this thing"
        end

        it "when a field is registered after instantation" do
            obj = TestInclude.new
            Dependo::Registry[:thing] = "this thing"
            obj.thing.should == "this thing"
        end

        it "when a field is registered with the same name as an existing instance method" do
            Dependo::Registry[:my_method] = "this method"
            obj = TestInclude.new
            obj.my_method.should == "my method"
        end

        it "when a field is registered with the same name as an attr_reader" do
            Dependo::Registry[:my_reader] = "this reader"
            obj = TestInclude.new
            obj.my_reader.should == "my reader"
        end

        it "when a field is registered with the same name as an attr_writer" do
            Dependo::Registry[:my_writer] = "this writer"
            obj = TestInclude.new
            obj.my_writer.should == "this writer"
        end

        it "when a field is registered with the same name as an attr_accessor" do
            Dependo::Registry[:my_accessor] = "this accessor"
            obj = TestInclude.new
            obj.my_accessor.should == "my accessor"
        end

        it "when a field is registered with the same name as an existing class method" do
            Dependo::Registry[:my_class_method] = "this is my class method"
            obj = TestInclude.new
            obj.my_class_method.should == "this is my class method"
            TestInclude.my_class_method.should == "my class method"
        end

        it "when a field is not registered" do
            obj = TestInclude.new
            expect { obj.not_provided }.to raise_error(NoMethodError, /undefined method 'not_provided' for #<TestInclude:0x[0-9a-f]+>/)
        end

        it "when a method is defined" do
            obj = TestInclude.new
            obj.should respond_to(:my_method)
        end

        it "when a method is not defined" do
            obj = TestInclude.new
            obj.should_not respond_to(:undefined_method)
        end

        it "when a method is injected" do
            Dependo::Registry[:thing] = "this thing"
            obj = TestInclude.new
            obj.should respond_to(:thing)
        end
    end

    context "extend" do
        class TestExtend
            extend Dependo::Mixin

            def my_instance_method
                "my instance method"
            end

            def self.my_method
                "my method"
            end
        end

        it "when a field is registered" do
            Dependo::Registry[:thing] = "my thing"
            TestExtend.thing.should == "my thing"
        end

        it "when a field is registered with the same name as an existing class method" do
            Dependo::Registry[:my_method] = "this method"
            TestExtend.my_method.should == "my method"
        end

        it "when a field is registered with the same name as an existing instance method" do
            Dependo::Registry[:my_instance_method] = "this instance method"
            TestExtend.my_instance_method.should == "this instance method"
            obj = TestExtend.new
            obj.my_instance_method.should == "my instance method"
        end

        it "when a field is not registered" do
            expect { TestExtend.not_provided }.to raise_error(NoMethodError, "undefined method 'not_provided' for TestExtend")
        end
    end

    context "include and extend" do
        class TestBoth
            include Dependo::Mixin
            extend Dependo::Mixin

            def my_instance_method
                "my instance method"
            end

            def self.my_class_method
                "my class method"
            end

            def both
                "instance both"
            end

            def self.both
                "class both"
            end
        end

        it "when a field is registered" do
            Dependo::Registry[:thing] = "this thing"
            TestBoth.thing.should == "this thing"
            obj = TestBoth.new
            obj.thing.should == "this thing"
        end

        it "when a field matches an instance method" do
            Dependo::Registry[:my_instance_method] = "this thing"
            TestBoth.my_instance_method.should == "this thing"
            obj = TestBoth.new
            obj.my_instance_method.should == "my instance method"
        end

        it "when a field matches a class method" do
            Dependo::Registry[:my_class_method] = "this thing"
            TestBoth.my_class_method.should == "my class method"
            obj = TestBoth.new
            obj.my_class_method.should == "this thing"
        end

        it "when a field matches both an instance and a class method" do
            Dependo::Registry[:both] = "this thing"
            TestBoth.both.should == "class both"
            obj = TestBoth.new
            obj.both.should == "instance both"
        end

        it "when a field is not registered" do
            expect { TestBoth.not_provided }.to raise_error(NoMethodError, "undefined method 'not_provided' for TestBoth")
            obj = TestBoth.new
            expect { obj.not_provided }.to raise_error(NoMethodError, /undefined method 'not_provided' for #<TestBoth:0x[0-9a-f]+>/)
        end
    end
end
