_ = require 'highland'
assert = require 'assert'
deepMatches = require 'mout/object/deepMatches'

snurra = require 'snurra'

snurra.register require '../index.coffee'

describe 'given an bus instance', ->
  bus = null
  envelopes = null

  beforeEach ->
    envelopes = []
    bus = snurra()
    _(bus.envelopes()).each (x) -> envelopes.push(x)

  it 'should do things', (done) ->
    hello = bus.request('hello')
    yello = bus.request('yello')

    yields = []
    _(hello).each yields.push.bind(yields)
    _(yello).each ->
    setTimeout ->
      assert.equal yields[0], 'Polo!'
      assert.equal yields.length, 1
      assert deepMatches envelopes[2],
        topic: 'snurra-response',
        message:
          topic: 'hello'
      assert deepMatches envelopes[3],
        topic: 'snurra-response',
        message:
          topic: 'yello'
      done()
    , 20

    hello.write 'Marco!'
    yello.write 'Marco!'
    bus.responder 'hello', -> _().map -> 'Polo!'
    bus.responder 'yello', -> _().map -> 'Poloy!'
