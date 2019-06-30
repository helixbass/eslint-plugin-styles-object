getStyleKeys = (stylesObject) ->
  key for {key, computed} in stylesObject.properties when key.type is 'Identifier' and not computed

isStylesheetCreateFunction = ({callee, stylesheetCreateFunction}) ->
  memberExpressionParts = stylesheetCreateFunction.split '.'
  currentMemberExpression = callee
  while memberExpressionParts.length
    if memberExpressionParts.length is 1
      return no unless currentMemberExpression.type is 'Identifier'
      property = currentMemberExpression
      object = null
    else
      return no unless currentMemberExpression.type is 'MemberExpression'
      {object, property} = currentMemberExpression
    return no unless property.type is 'Identifier'
    currentPart = memberExpressionParts.pop()
    return no unless currentPart is property.name
    currentMemberExpression = object
  yes

isStylesDeclaration = ({node, context: {settings}}) ->
  return no unless node?.id?.name is 'styles'
  {init} = node
  return {styleKeys: getStyleKeys(init)} if init.type is 'ObjectExpression'
  return no unless init.type is 'CallExpression'
  return no unless stylesheetCreateFunction = settings['styles-object/stylesheet-create-function']
  {callee, arguments: args} = init
  return no unless isStylesheetCreateFunction {callee, stylesheetCreateFunction}
  return no unless args[0]?.type is 'ObjectExpression'
  styleKeys: getStyleKeys(args[0])

isStyleReference = (node) ->
  return no unless node.object.name is 'styles'
  return no unless node.property.type is 'Identifier'
  return no if node.computed
  yes

module.exports = {isStylesDeclaration, isStyleReference}
