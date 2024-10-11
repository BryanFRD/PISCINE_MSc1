import dotenv from 'dotenv'
import { createApp } from 'vue'

import App from './App.vue'
import router from './router'

import './styles.css'

dotenv.config()

createApp(App).use(router).mount('#app')
