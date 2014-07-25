sinon = require 'sinon'
chai = require 'chai'
expect = chai.expect
chai.should()

list = require '../index.coffee'

describe 'given stuff', ->
  clock = null
  beforeEach -> clock = sinon.useFakeTimers()
  afterEach  -> clock.restore()

  it 'should do things', ->
