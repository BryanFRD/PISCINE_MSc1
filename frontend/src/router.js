import { createRouter, createWebHistory } from 'vue-router'

import ChartManager from './components/chartManager/ChartManager.vue'
import ClockManager from './components/clocks/ClockManager.vue'
import Layout from './components/layout/Layout.vue'
import User from './components/user/User.vue'
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
        { path: '/:userId', name: 'user', component: User },
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
    }
  ]
})

export default router
