module TheCommentsViewHelper
  def the_comments_template template_name
    "the_comments/#{ TheCommentsBase.config.template_engine }/#{ template_name }"
  end
end
