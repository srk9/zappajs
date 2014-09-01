zappa = require '../src/zappa'
port = 15200

@tests =
  client: (t) ->
    t.expect 1, 2, 3, 4, 5
    t.wait 3000

    zapp = zappa port++, ->
      @client '/index.js': ->
        @get '#/': -> alert 'hi'

    c = t.client(zapp.server)
    c.get '/index.js', (err, res) ->
      t.equal 1, res.body, ';zappa.run(function () {\n            return this.get({\n              \'#/\': function() {\n                return alert(\'hi\');\n              }\n            });\n          });'
      t.equal 2, res.headers['content-type'], 'application/javascript'
    c.get '/zappa/zappa.js', (err, res) ->
      t.equal 3, res.headers['content-type'], 'application/javascript'
    c.get '/zappa/jquery.js', (err, res) ->
      t.equal 4, res.headers['content-type'], 'application/javascript'
    c.get '/zappa/sammy.js', (err, res) ->
      t.equal 5, res.headers['content-type'], 'application/javascript'

  coffee: (t) ->
    t.expect 1, 2
    t.wait 3000

    zapp = zappa port++, ->
      @coffee '/coffee.js': ->
        alert 'hi'

    c = t.client(zapp.server)
    c.get '/coffee.js', (err, res) ->
      t.equal 1, res.body, ';var __slice = Array.prototype.slice;var __hasProp = Object.prototype.hasOwnProperty;var __bind = function(fn, me){  return function(){ return fn.apply(me, arguments); };};var __extends = function(child, parent) {  for (var key in parent) {    if (__hasProp.call(parent, key)) child[key] = parent[key];  }  function ctor() { this.constructor = child; }  ctor.prototype = parent.prototype;  child.prototype = new ctor;  child.__super__ = parent.prototype;  return child;};var __indexOf = Array.prototype.indexOf || function(item) {  for (var i = 0, l = this.length; i < l; i++) {    if (this[i] === item) return i;  } return -1; };(function () {\n            return alert(\'hi\');\n          })();'
      t.equal 2, res.headers['content-type'], 'application/javascript'

  js: (t) ->
    t.expect 1, 2
    t.wait 3000

    zapp = zappa port++, ->
      @js '/js.js': '''
        alert('hi');
      '''

    c = t.client(zapp.server)
    c.get '/js.js', (err, res) ->
      t.equal 1, res.body, "alert('hi');"
      t.equal 2, res.headers['content-type'], 'application/javascript'

  css: (t) ->
    t.expect 1, 2
    t.wait 3000

    zapp = zappa port++, ->
      @css '/index.css': '''
        body { font-family: sans-serif; }
      '''

    c = t.client(zapp.server)
    c.get '/index.css', (err, res) ->
      t.equal 1, res.body, 'body { font-family: sans-serif; }'
      t.equal 2, res.headers['content-type'], 'text/css'

  coffee_css: (t) ->
    t.expect 1, 2
    t.wait 3000

    zapp = zappa port++, ->
      border_radius = (radius)->
        WebkitBorderRadius: radius
        MozBorderRadius: radius
        borderRadius: radius

      @css '/index.css':
        body:
          font: '12px Helvetica, Arial, sans-serif'

        'a.button':
          border_radius '5px'

    c = t.client(zapp.server)
    c.get '/index.css', (err, res) ->
      t.equal 1, res.body, '''
        body {
            font: 12px Helvetica, Arial, sans-serif;
        }
        a.button {
            -webkit-border-radius: 5px;
            -moz-border-radius: 5px;
            border-radius: 5px;
        }
      '''
      t.equal 2, res.headers['content-type'], 'text/css'

  stylus: (t) ->
    t.expect 'header', 'body'
    t.wait 3000

    zapp = zappa port++, ->
      @with css:'stylus'
      @stylus '/index.css': '''
        border-radius()
          -webkit-border-radius arguments
          -moz-border-radius arguments
          border-radius arguments

        body
          font 12px Helvetica, Arial, sans-serif

        a.button
          border-radius 5px
      '''

    c = t.client(zapp.server)
    c.get '/index.css', (err, res) ->
      t.equal 'header', res.headers['content-type'], 'text/css'
      t.equal 'body', res.body, '''
        body {
          font: 12px Helvetica, Arial, sans-serif;
        }
        a.button {
          -webkit-border-radius: 5px;
          -moz-border-radius: 5px;
          border-radius: 5px;
        }

      '''

  less: (t) ->
    t.expect 'header', 'body'
    t.wait 3000

    zapp = zappa port++, ->
      @with css:'less'
      @less '/index.css': '''
        .border-radius(@radius) {
          -webkit-border-radius: @radius;
          -moz-border-radius: @radius;
          border-radius: @radius;
        }

        body {
          font: 12px Helvetica, Arial, sans-serif;
        }

        a.button {
          .border-radius(5px);
        }
      '''

    c = t.client(zapp.server)
    c.get '/index.css', (err, res) ->
      t.equal 'header', res.headers['content-type'], 'text/css'
      t.equal 'body', res.body, '''
        body {
          font: 12px Helvetica, Arial, sans-serif;
        }
        a.button {
          -webkit-border-radius: 5px;
          -moz-border-radius: 5px;
          border-radius: 5px;
        }

      '''

  jquery: (t) ->
    t.expect 'content-type', 'length'
    t.wait 3000

    zapp = zappa port++, ->
      @use 'zappa'

    c = t.client(zapp.server)
    c.get '/zappa/jquery.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.equal 'length', res.headers['content-length'], '96519'
      t.equal 'body-length', res.body.length, 96519

  sammy: (t) ->
    t.expect 'content-type', 'length'
    t.wait 3000

    zapp = zappa port++, ->
      @use 'zappa'

    c = t.client(zapp.server)
    c.get '/zappa/sammy.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.equal 'length', res.headers['content-length'], '18958'
      t.equal 'body-length', res.body.length, 18958

  'socket.io': (t) ->
    t.expect 'content-type', 'length'
    t.wait 3000

    zapp = zappa port++, ->

    c = t.client(zapp.server)
    c.get '/socket.io/socket.io.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.equal 'length', res.body.length, 155212

  zappa: (t) ->
    t.expect 'content-type', 'snippet'
    t.wait 3000

    zapp = zappa port++, ->
      @use 'zappa'

    c = t.client(zapp.server)
    c.get '/zappa/zappa.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.ok 'snippet', res.body.indexOf('window.zappa = {};') > -1

  Zappa: (t) ->
    t.expect 'content-type', 'snippet'
    t.wait 3000

    zapp = zappa port++, ->
      @use 'zappa'

    c = t.client(zapp.server)
    c.get '/zappa/Zappa.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.ok 'snippet', res.body.indexOf('window.zappa = {};') > -1

  'zappa (automatic)': (t) ->
    t.expect 'content-type', 'snippet'
    t.wait 3000

    zapp = zappa port++, ->
      @client '/index.js': ->

    c = t.client(zapp.server)
    c.get '/zappa/zappa.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.ok 'snippet', res.body.indexOf('window.zappa = {};') > -1

  minify: (t) ->
    t.expect 'zappa', 'client', 'shared', 'coffee', 'js'
    t.wait 3000

    zapp = zappa port++, ->
      @enable 'minify'
      @client '/client.js': -> alert 'foo'
      @shared '/shared.js': -> alert 'foo' if window?
      @coffee '/coffee.js': -> alert 'foo'
      @js '/js.js': "alert('foo');"

    c = t.client(zapp.server)
    c.get '/zappa/zappa.js', (err, res) ->
      t.ok 'zappa', res.body.indexOf('window.zappa={},') > -1
    c.get '/client.js', (err, res) ->
      t.equal 'client', res.headers['content-length'], '43'
    c.get '/shared.js', (err, res) ->
      t.equal 'shared', res.headers['content-length'], '91'
    c.get '/coffee.js', (err, res) ->
      t.equal 'coffee', res.headers['content-length'], '475'
    c.get '/js.js', (err, res) ->
      t.equal 'js', res.headers['content-length'], '13'

  zappa_prefix: (t) ->
    t.expect 1, 2, 3, 4, 5
    t.wait 3000

    zapp = zappa port++, ->
      @set zappa_prefix: '/myapp/zappa'
      @client '/myapp/index.js': ->
        @get '#/': -> alert 'hi'

    c = t.client(zapp.server)
    c.get '/myapp/index.js', (err, res) ->
      t.equal 1, res.body, ';zappa.run(function () {\n            return this.get({\n              \'#/\': function() {\n                return alert(\'hi\');\n              }\n            });\n          });'
      t.equal 2, res.headers['content-type'], 'application/javascript'
    c.get '/myapp/zappa/zappa.js', (err, res) ->
      t.equal 3, res.headers['content-type'], 'application/javascript'
    c.get '/myapp/zappa/jquery.js', (err, res) ->
      t.equal 4, res.headers['content-type'], 'application/javascript'
    c.get '/myapp/zappa/sammy.js', (err, res) ->
      t.equal 5, res.headers['content-type'], 'application/javascript'

  'socket.io_path': (t) ->
    t.expect 'content-type', 'length'
    t.wait 3000

    zapp = zappa port++, io:{path:'/myapp/socket.io'}, ->

    c = t.client(zapp.server)
    c.get '/myapp/socket.io/socket.io.js', (err, res) ->
      t.equal 'content-type', res.headers['content-type'], 'application/javascript'
      t.equal 'length', res.body.length, 155212
