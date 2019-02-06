isStylesDeclaration = (node) ->
  return no unless node.id.name is 'styles'
  return no unless node.init.type is 'ObjectExpression'
  yes

isStyleReference = (node) ->
  return no unless node.object.name is 'styles'
  return no unless node.property.type is 'Identifier'
  return no if node.computed
  yes

module.exports = {isStylesDeclaration, isStyleReference}
