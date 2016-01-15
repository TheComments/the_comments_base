# TheCommentsHighlight.init()
@TheCommentsHighlight = do ->
  highlight_anchor: ->
    hash = document.location.hash
    if hash.match('#comment_')
      $(hash).addClass 'the_comments--highlighted'

  init: ->
    @highlight_anchor()

    $(window).on 'hashchange', =>
      $('.comment.the_comments--highlighted').removeClass 'the_comments--highlighted'
      @highlight_anchor()
