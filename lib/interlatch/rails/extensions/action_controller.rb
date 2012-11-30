module Interlatch
  module Rails
    module Extensions
      module ActionController
        def caching_key(tag = nil, scope = nil)
          options = { controller: controller_name, action: action_name, id: params[:id], tag: tag }
          if scope == :global
            options.merge! controller: 'any', action: 'any', id: 'any'
          elsif scope == :controller
            options.merge! action: 'any', id: 'any'
          elsif scope == :action
            options.merge! id: 'any'
          end
          locale = Interlatch.locale_method ? self.send(Interlatch.locale_method) : nil

          Interlatch.caching_key(options[:controller], options[:action], options[:id], options[:tag], locale)
        end

        def behavior_cache(*args, &block)
          options = args.extract_options!

          key = caching_key(options[:tag], options[:scope])
          unless fragment_exist? key
            yield
            Interlatch.add_dependencies(key, args)
          end
        end

        private
      end
    end
  end
end

ActionController::Base.send(:include, Interlatch::Rails::Extensions::ActionController)
