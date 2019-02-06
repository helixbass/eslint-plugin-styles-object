{flow, map: fmap} = require 'lodash/fp'

ruleNames = ['no-unused-styles']

rules = do flow(
  -> ruleNames
  fmap (rule) -> require "./rules/#{rule}"
)

module.exports = {rules}
