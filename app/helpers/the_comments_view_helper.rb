module TheCommentsViewHelper
  def comment_template template_name
    "the_comments/#{ TheCommentsBase.config.template_engine }/#{ template_name }"
  end
end
