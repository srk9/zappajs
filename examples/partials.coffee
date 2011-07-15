require('../src/zappa').run ->
  get '/': ->
    @items = [
      {name: 'coffeescript', url: 'http://coffeescript.org'}
      {name: 'ruby', url: 'http://ruby-lang.org'}
      {name: 'python', url: 'http://python.org'}
    ]

    render 'index', options: {format: yes}

  view index: ->
    ul ->
      for i in @items
        partial 'item', i: i

  view item: ->
    li -> a href: @i.url, -> @i.name