import prettierConfig from '@vue/eslint-config-prettier'
import pluginVue from 'eslint-plugin-vue'

export default [
  ...pluginVue.configs['flat/recommended'],
  prettierConfig,
  {
    rules: {
      'vue/multi-word-component-names': 'off',
      'vue/require-default-prop': 'off',
      'prettier/prettier': ['warn', { endOfLine: 'auto' }]
    }
  }
]
