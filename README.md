# TheCommentsBase

**FRONTEND**

```coffee
#= require jquery2
#= require jquery_ujs
#= require turbolinks

#= require jquery.data-role-selector

#= require the_comments/default_notificator
#= require the_comments/base

$(document).on 'ready page:load', ->
  notificator = TheCommentsDefaultNotificator
  TheComments.init(notificator)
  TheCommentsHighlight.init()

  TheComments.i18n =
    server_error: "Ошибка сервера: {code}"
    please_wait: "Пожалуйста подождите {sec} сек."
    succesful_created: "Комментарий успешно создан"
```

```sass
#= require the_comments/base
```