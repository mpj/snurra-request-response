_ = require 'highland'

module.exports =

  request: (bus, topic) ->
    _.pipeline (input) -> _(input).flatMap (message) ->
      id = Math.floor Math.random() * 10000000
      bus('snurra-request').write
        correlation_id: id
        topic: topic
        content: message
      _(bus('snurra-response'))
        .filter((x) -> x.correlation_id is id)
        .pluck('content')

  responder: (bus, topic, constructor) ->
    _(bus('snurra-request'))
      .filter((x) -> x.topic is topic)
      .each (r) ->
        transform = constructor()
        transform.map((x) ->
          correlation_id: r.correlation_id
          topic: topic
          content: x
        ).pipe bus('snurra-response')
        transform.write r.content
