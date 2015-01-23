React = require 'react-atom-fork'
{div} = require 'reactionary-atom-fork'
{isEqualForProperties} = require 'underscore-plus'

module.exports =
HighlightComponent = React.createClass
  displayName: 'HighlightComponent'

  render: ->
    {editor, state} = @props

    console.log 'state', state

    className = 'highlight'
    className += " #{state.class}" if state.class?

    div {className},
      for region, i in state.regions
        console.log 'region', region
        regionClassName = 'region'
        regionClassName += " #{state.deprecatedRegionClass}" if state.deprecatedRegionClass?
        div className: regionClassName, key: i, style: region

  componentDidMount: ->
    {editor, key} = @props
    @decoration = editor.decorationForId(key)
    @decorationDisposable = @decoration.onDidFlash @startFlashAnimation
    @startFlashAnimation()

  componentWillUnmount: ->
    @decorationDisposable?.dispose()
    @decorationDisposable = null

  startFlashAnimation: ->
    return unless flash = @decoration.consumeNextFlash()

    node = @getDOMNode()
    node.classList.remove(flash.class)

    requestAnimationFrame =>
      node.classList.add(flash.class)
      clearTimeout(@flashTimeoutId)
      removeFlashClass = -> node.classList.remove(flash.class)
      @flashTimeoutId = setTimeout(removeFlashClass, flash.duration)
