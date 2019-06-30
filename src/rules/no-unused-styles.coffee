{isStylesDeclaration, isStyleReference} = require '../util'

module.exports =
  meta:
    docs:
      description: 'Enforce that all styles are used'
      category: 'Possible Errors'
      recommended: yes
    schema: []

  create: (context) ->
    styleKeys = null
    styleReferences = []

    VariableDeclarator: (node) ->
      isDeclaration = isStylesDeclaration {node, context}
      return unless isDeclaration
      {styleKeys} = isDeclaration

    MemberExpression: (node) ->
      return unless isStyleReference node
      styleReferences.push node.property.name

    'Program:exit': ->
      return unless styleKeys?.length
      for key in styleKeys
        continue if key.name in styleReferences
        context.report key, "Unused style detected: #{key.name}"
