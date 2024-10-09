import { createRouter, createWebHistory } from 'vue-router'
import UserView from './components/user/UserView.vue'

const routes = [{ path: '/:userId', name: 'user', component: UserView }]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
