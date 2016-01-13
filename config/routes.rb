module TheCommentsBase
  # ::TheCommentsBase::Routes.mixin(self)
  class Routes
    def self.mixin mapper
      mapper.extend ::TheCommentsBase::DefaultRoutes
      mapper.send :comments_base_routes
    end
  end

  module DefaultRoutes
    def comments_base_routes
      resources :comments, only: :create
    end
  end
end
