json.comment render(partial: 'the_comments/tree/comment.html', locals: { tree: @comment })
json.comments_sum @commentable.reload.comments_sum
