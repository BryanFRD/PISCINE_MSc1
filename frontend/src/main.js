import { createApp } from 'vue'

import App from './App.vue'
import router from './router'

import './styles.css'

console.log(import.meta.env)

createApp(App).use(router).mount('#app')
