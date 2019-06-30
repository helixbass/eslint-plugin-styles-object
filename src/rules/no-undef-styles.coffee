{isStylesDeclaration, isStyleReference} = require '../util'

module.exports =
  meta:
    docs:
      description: 'Enforce that no undefined styles are referenced'
      category: 'Possible Errors'
      recommended: yes
    schema: []

  create: (context) ->
    styleKeys = null
    styleReferences = []
    hasSeenStylesDeclaration = no

    VariableDeclarator: (node) ->
      isDeclaration = isStylesDeclaration {node, context}
      return unless isDeclaration
      hasSeenStylesDeclaration = yes
      {styleKeys} = isDeclaration
      styleKeys = (key.name for key in styleKeys)

    MemberExpression: (node) ->
      return unless isStyleReference node
      styleReferences.push node.property

    'Program:exit': ->
      return unless hasSeenStylesDeclaration
      for reference in styleReferences
        continue if reference.name in styleKeys
        context.report reference, "Undefined style detected: #{reference.name}"
