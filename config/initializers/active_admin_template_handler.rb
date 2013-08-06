module ActiveAdmin
  class CustomTemplateHandler
    def call(template)
      <<-END
      Arbre::Context.new(assigns, self) {
        #{ template.source }
      }.to_s
      END
    end
  end
end

ActionView::Template.register_template_handler :aa, ActiveAdmin::CustomTemplateHandler.new
