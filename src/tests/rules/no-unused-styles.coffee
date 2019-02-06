rule = require '../../rules/no-unused-styles'
{RuleTester} = require 'eslint'

ruleTester = new RuleTester()

error = (key) ->
  message: "Unused style detected: styles.#{key}"

tests =
  valid: [
    code: 'const styles = 1'
  ,
    code: 'const styles = {}'
  ,
    code: '''
      const styles = {
        a: {
          height: 1
        },
        b: {
          height: 2
        }
      }

      render(
        <div css={styles.a}>
          <span css={styles.b}>yes</span>
        </div>
      )
    '''
  ]
  invalid: [
    code: '''
      const styles = {a: 1}

      render(<div css={styles.ab} />)
    '''
    errors: [error('a')]
  ]

config =
  parser: 'babel-eslint'
  parserOptions:
    ecmaVersion: 2018
    ecmaFeatures:
      jsx: yes

Object.assign(test, config) for test in [...tests.valid, ...tests.invalid]

ruleTester.run 'no-unused-styles', rule, tests
