module TheCommentsBase
  # TheCommentsBase::Routes.mixin(self)
  class Routes
    def self.mixin mapper
      mapper.resources :comments, only: :create
    end
  end
end
