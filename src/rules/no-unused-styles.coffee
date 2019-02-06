isStylesDeclaration = (node) ->
  return no unless node.id.name is 'styles'
  return no unless node.init.type is 'ObjectExpression'
  yes

isStyleReference = (node) ->
  return no unless node.object.name is 'styles'
  return no unless node.property.type is 'Identifier'
  return no if node.computed
  yes

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
      return unless isStylesDeclaration node
      styleKeys = (key for {key, computed} in node.init.properties when key.type is 'Identifier' and not computed)

    MemberExpression: (node) ->
      return unless isStyleReference node
      styleReferences.push node.property.name

    'Program:exit': ->
      return unless styleKeys?.length
      for key in styleKeys
        continue if key.name in styleReferences
        context.report key, "Unused style detected: styles.#{key.name}"
