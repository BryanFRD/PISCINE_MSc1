<script setup>
import { onMounted } from 'vue'

import { Toaster } from '@/components/ui/sonner'

import { instance } from './api/instance'
import { useAuthStore } from './stores/authStore'

const authStore = useAuthStore()

const getCurrentUser = async () => {
  try {
    const token = localStorage.getItem('time-manager-token')

    const result = await instance.get('/auth/profile', {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })

    if (result.data) {
      authStore.user = result.data
    }

    authStore.isFetched = true
  } catch {}
}

onMounted(() => {
  getCurrentUser()
})
</script>

<template>
  <RouterView />

  <Toaster />
</template>
