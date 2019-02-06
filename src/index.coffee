{flow, map: fmap, fromPairs: ffromPairs} = require 'lodash/fp'

ruleNames = ['no-unused-styles', 'no-undef-styles']

rules = do flow(
  -> ruleNames
  fmap (ruleName) -> [ruleName, require "./rules/#{ruleName}"]
  ffromPairs
)

module.exports = {rules}
