slug = (s) ->
  s
    .toLowerCase()
    .replace (/ /g), '-'
    .replace /[-]+/g, '-'
    .replace /[^\w-]+/g, ''

$ '#title'
  .change (e) ->
    s = $(@).val()
    $ '#slug'
      .val slug s

bodyRenderTimeout = null
$body = $ '#body'
$body
  .keyup (e) ->
    if bodyRenderTimeout? then clearTimeout bodyRenderTimeout
    bodyRenderTimeout = setTimeout () ->
        $ '#markup'
          .html marked($body.val())
      , 200
  .keyup()