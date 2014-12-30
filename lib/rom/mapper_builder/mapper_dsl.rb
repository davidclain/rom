require 'rom/mapper_builder/model_dsl'

module ROM
  class MapperBuilder
    # @api private
    class MapperDSL
      include ModelDSL

      attr_reader :attributes, :options, :symbolize_keys, :prefix

      def initialize(attributes, options = {})
        @attributes = attributes
        @options = options
        @symbolize_keys = options.fetch(:symbolize_keys) { false }
        @prefix = options.fetch(:prefix) { false }
        super
      end

      def attribute(name, options = {})
        with_attr_options(name, options) do |attr_options|
          add_attribute(name, attr_options)
        end
      end

      def exclude(*names)
        names.each { |name| attributes.delete([name]) }
      end

      def embedded(name, options = {}, &block)
        with_attr_options(name, options) do |attr_options|
          dsl = new(options, &block)

          add_attribute(
            name,
            { header: dsl.header, type: :array }.update(attr_options)
          )
        end
      end

      def wrap(*args, &block)
        with_name_or_options(*args) do |name, options|
          dsl(name, { type: :hash, wrap: true }.update(options), &block)
        end
      end

      def group(*args, &block)
        with_name_or_options(*args) do |name, options|
          dsl(name, { type: :array, group: true }.update(options), &block)
        end
      end

      def header
        Header.coerce(attributes, model)
      end

      private

      def with_attr_options(name, options)
        attr_options = options.dup

        attr_prefix = options[:prefix] || prefix
        attr_options[:from] ||= :"#{attr_prefix}_#{name}" if attr_prefix

        if symbolize_keys
          attr_options.update(from: attr_options.fetch(:from) { name }.to_s)
        end

        yield(attr_options)
      end

      def with_name_or_options(*args)
        name, options =
          if args.size > 1
            args
          else
            [args.first, {}]
          end

        yield(name, options)
      end

      def dsl(name_or_attrs, options, &block)
        if block
          attributes_from_block(name_or_attrs, options, &block)
        else
          attributes_from_hash(name_or_attrs, options)
        end
      end

      def attributes_from_block(name, options, &block)
        dsl = new(options, &block)
        add_attribute(name, options.update(header: dsl.header))
      end

      def attributes_from_hash(hash, options)
        hash.each do |name, header|
          with_attr_options(name, options) do |attr_options|
            add_attribute(name, attr_options.update(header: header.zip))
          end
        end
      end

      def add_attribute(name, options)
        exclude(name, name.to_s)
        attributes << [name, options]
      end

      def new(options, &block)
        dsl_options = @options.merge(options)
        dsl_options.update(prefix: options.fetch(:prefix) { prefix })
        dsl = self.class.new([], dsl_options)
        dsl.instance_exec(&block)
        dsl
      end
    end
  end
end