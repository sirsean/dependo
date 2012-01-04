# Dependency Injection Framework
module Dependo
    # The gem version
    VERSION = "0.1"

    # Where dependencies are specified (or registered), and stored for future use
    class Registry
        @@attributes = {}

        # The Registry cannot be instantiated, so this constructor just fails
        def initialize
            raise "Cannot instantiate Dependo::Registry"
        end

        # @param key [symbol] the name of the dependency to register
        # @param value [Object] the dependency to register
        def self.[]=(key, value)
            @@attributes[key] = value
        end

        # @param key [symbol] the name of the registered dependency
        # @return the dependency registered with the given name
        def self.[](key)
            @@attributes[key]
        end

        # @param key [symbol] the name of the registered dependency
        # @return true if the name is registered, false otherwise
        def self.has_key?(key)
            @@attributes.has_key?(key)
        end

        # Remove all dependencies from the registry
        def self.clear
            @@attributes.clear
        end
    end

    # Allows dependencies to be injected into your classes. This can be done using both "include"
    # or "extend", depending on whether you need to use the dependencies as instance methods or
    # class methods. Note that you can also do both.
    module Mixin
        # @param key [symbol] the name of the method that didn't exist on your object or class
        # @return the injected dependency in the Dependo::Registry with the given name
        # @raise NoMethodError if the name is not registered
        def method_missing(key)
            if Dependo::Registry.has_key?(key)
                Dependo::Registry[key]
            else
                raise NoMethodError, "undefined method '#{key.to_s}' for #{self.to_s}"
            end
        end
    end
end
