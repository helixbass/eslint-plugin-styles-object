rule = require '../../rules/no-undef-styles'
{RuleTester} = require 'eslint'

ruleTester = new RuleTester()

error = (key) ->
  message: "Undefined style detected: #{key}"

tests =
  valid: [
    code: 'styles.a'
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
      render(<div css={styles.a} />)

      const styles = {b: 1}
    '''
    errors: [error('a')]
  ,
    # empty styles object
    code: '''
      render(<div css={styles.a} />)

      const styles = {}
    '''
    errors: [error('a')]
  ,
    # stylesheet-create-function
    code: '''
      render(<div css={styles.a} />)

      const styles = createStylesheet({b: 1})
    '''
    errors: [error('a')]
    settings:
      'styles-object/stylesheet-create-function': 'createStylesheet'
  ,
    # stylesheet-create-function member expression
    code: '''
      render(<div css={styles.a} />)

      const styles = StyleSheet.create({b: 1})
    '''
    errors: [error('a')]
    settings:
      'styles-object/stylesheet-create-function': 'StyleSheet.create'
  ]

config =
  parser: 'babel-eslint'
  parserOptions:
    ecmaVersion: 2018
    ecmaFeatures:
      jsx: yes

Object.assign(test, config) for test in [...tests.valid, ...tests.invalid]

ruleTester.run 'no-undef-styles', rule, tests
