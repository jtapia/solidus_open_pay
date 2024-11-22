# frozen_string_literal: true

module SolidusOpenPay
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :migrate, type: :boolean, default: true
      class_option :backend, type: :boolean, default: true
      class_option :frontend, type: :string, default: 'starter'

      # This is only used to run all-specs during development and CI,  regular installation limits
      # installed specs to frontend, which are the ones related to code copied to the target application.
      class_option :specs, type: :string, enum: %w[all frontend], default: 'frontend', hide: true

      source_root File.expand_path('templates', __dir__)

      def normalize_components_options
        @components = {
          backend: options[:backend],
          starter_frontend: options[:frontend] == 'starter',
          classic_frontend: options[:frontend] == 'classic',
        }
      end

      def install_solidus_core_support
        directory 'config/initializers', 'config/initializers'
        rake 'railties:install:migrations FROM=solidus_open_pay'
        run 'bin/rails db:migrate' if options[:migrate]
        route "mount SolidusOpenPay::Engine, at: '#{solidus_mount_point}solidus_open_pay'"
      end

      def install_solidus_backend_support
        support_code_for(:backend) do
          append_file(
            'vendor/assets/javascripts/spree/backend/all.js',
            "//= require spree/backend/solidus_open_pay\n"
          )
          inject_into_file(
            'vendor/assets/stylesheets/spree/backend/all.css',
            " *= require spree/backend/solidus_open_pay\n",
            before: %r{\*/},
            verbose: true,
          )
        end
      end

      def install_solidus_starter_frontend_support
        support_code_for(:starter_frontend) do
          directory 'app', 'app'
          append_file(
            'app/assets/javascripts/solidus_starter_frontend.js',
            "//= require spree/frontend/solidus_open_pay\n"
          )
          inject_into_file(
            'app/assets/stylesheets/solidus_starter_frontend.css',
            " *= require spree/frontend/solidus_open_pay\n",
            before: %r{\*/},
            verbose: true,
          )

          spec_paths =
            case options[:specs]
            when 'all' then %w[spec]
            when 'frontend'
              %w[
                spec/spec_helper.rb
                spec/support
              ]
            end

          spec_paths.each do |path|
            if engine.root.join(path).directory?
              directory engine.root.join(path), path
            else
              template engine.root.join(path), path
            end
          end
        end
      end

      # def alert_no_classic_frontend_support
      #   support_code_for(:classic_frontend) do
      #     message = <<~TEXT
      #       For solidus_frontend compatibility, please use the deprecated version 0.x.
      #       The new version of this extension only supports Solidus Starter Frontend.
      #       No frontend code has been copied to your application.
      #     TEXT
      #     say_status :error, set_color(message.tr("\n", ' '), :red), :red
      #   end
      # end

      private

      def solidus_mount_point
        mount_point = ::Spree::Core::Engine.routes.find_script_name({})
        mount_point += '/' unless mount_point.end_with?('/')
        mount_point
      end

      def support_code_for(component_name, &block)
        if @components[component_name]
          say_status :install, "[#{engine.engine_name}] solidus_#{component_name}", :blue
          shell.indent(&block)
        else
          say_status :skip, "[#{engine.engine_name}] solidus_#{component_name}", :blue
        end
      end

      def engine
        SolidusOpenPay::Engine
      end
      # class_option :auto_run_migrations, type: :boolean, default: false

      # def add_javascripts
      #   append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/solidus_open_pay\n"
      #   append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/solidus_open_pay\n"
      # end

      # def add_stylesheets
      #   inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/solidus_open_pay\n", before: /\*\//, verbose: true
      #   inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/solidus_open_pay\n", before: /\*\//, verbose: true
      # end

      # def add_migrations
      #   run 'bundle exec rake railties:install:migrations FROM=solidus_open_pay'
      # end

      # def run_migrations
      #   run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(
      #     ask('Would you like to run the migrations now? [Y/n]')
      #   )
      #   if run_migrations
      #     run 'bundle exec rake db:migrate'
      #   else
      #     puts 'Skipping rake db:migrate, don\'t forget to run it!' # rubocop:disable Rails/Output
      #   end
      # end
    end
  end
end
