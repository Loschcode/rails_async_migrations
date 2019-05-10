module RailsAsyncMigrations
  module DefineMethodIn
    # `klass.define_method(...)` does not work in Ruby 2.4. Work around.
    def define_method_in(klass, name, &block)
      klass.class_exec {
        define_method(name, &block)
      }
    end
  end
end