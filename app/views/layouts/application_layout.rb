# frozen_string_literal: true

class ApplicationLayout < ApplicationView
  include Phlex::Rails::Layout

  def view_template(&block)
    doctype

    html(class: "dark js-focus-visible") do
      head do
        title { Rails.application.name.tr("-", " ").humanize }
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        csp_meta_tag
        csrf_meta_tags
        stylesheet_link_tag "application", data_turbo_track: "reload"
        javascript_include_tag "application", data_turbo_track: "reload", type: "module"
        script do
          <<~JS
            if (window.history.state && window.history.state.turbo) {
              window.addEventListener("popstate", function () { location.reload(true); });
            }
          JS
        end
      end

      body(class: "antialiased text-slate-500 dark:text-slate-400 bg-white dark:bg-slate-900") do
        render NavComponent.new do |nav|
          nav.item(items_path) { "Items" }
          nav.item("/foo") { "Builds" }
        end
        p { yield :message }
        main do
          yield
        end
      end
    end
  end
end
