module ROM
  module Plugins
    module Relation
      module SQL
        module AutoCombine
          # @api private
          def self.included(klass)
            super
            klass.include(InstanceInterface)
            klass.extend(ClassInterface)
          end

          module ClassInterface
            def inherited(klass)
              super
              klass.auto_curry :for_combine
            end
          end

          module InstanceInterface
            # Default methods for fetching combined relation
            #
            # This method is used by default by `combine`
            #
            # @return [SQL::Relation]
            #
            # @api private
            def for_combine(keys, relation)
              pk, fk = keys.to_a.flatten
              where(fk => relation.map { |tuple| tuple[pk] })
            end
          end
        end
      end
    end
  end

  plugins do
    adapter :sql do
      register :auto_combine, Plugins::Relation::SQL::AutoCombine, type: :relation
    end
  end
end
