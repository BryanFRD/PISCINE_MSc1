import { createRouter, createWebHistory } from 'vue-router'

import Login from './components/auth/Login.vue'
import Public from './components/auth/Public.vue'
import Register from './components/auth/Register.vue'
import ChartManager from './components/chartManager/ChartManager.vue'
import ClockManager from './components/clocks/ClockManager.vue'
import Home from './components/home/Home.vue'
import Layout from './components/layout/Layout.vue'
import Account from './components/user/Account.vue'
import CreateWorkingTime from './components/workingTime/CreateWorkingTime.vue'
import WorkingTimeManager from './components/workingTime/WorkingTimeManager.vue'
import WorkingTimes from './components/workingTimes/WorkingTimes.vue'

const router = createRouter({
  history: createWebHistory(),
  routes: [
    {
      path: '/',
      component: Layout,
      children: [
        { path: '/', name: 'home', component: Home },
        { path: '/account', name: 'account', component: Account },
        { path: '/clock/:userId', name: 'clock', component: ClockManager },
        {
          path: '/working-times/:userId',
          name: 'working-times',
          component: WorkingTimes
        },
        {
          path: '/working-time/:userId/:workingTimeId',
          name: 'working-time',
          component: WorkingTimeManager
        },
        {
          path: '/working-time/:userId',
          name: 'working-time-create',
          component: CreateWorkingTime
        },
        {
          path: '/chart-manager/:userId',
          name: 'chart-manager',
          component: ChartManager
        }
      ]
    },
    {
      path: '/',
      component: Public,
      children: [
        { path: '/login', name: 'login', component: Login },
        { path: '/register', name: 'register', component: Register }
      ]
    }
  ]
})

export default router
