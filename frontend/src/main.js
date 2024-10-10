import { setDefaultOptions } from 'date-fns'
import { fr } from 'date-fns/locale'
import { createApp } from 'vue'

import App from './App.vue'
import router from './router'

import './styles.css'

// Set the default locale to French (date-fns)
setDefaultOptions({ locale: fr })

createApp(App).use(router).mount('#app')
