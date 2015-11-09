module.exports =
  slug: (s) ->
    s
      .toLowerCase()
      .replace (/ /g), '-'
      .replace /[-]+/g, '-'
      .replace /[^\w-]+/g, ''
