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

    VariableDeclarator: (node) ->
      return unless isStylesDeclaration node
      styleKeys = (key.name for {key, computed} in node.init.properties when key.type is 'Identifier' and not computed)

    MemberExpression: (node) ->
      return unless isStyleReference node
      styleReferences.push node.property

    'Program:exit': ->
      return unless styleKeys?.length
      for reference in styleReferences
        continue if reference.name in styleKeys
        context.report reference, "Undefined style detected: #{reference.name}"
