<script setup>
import { watchEffect } from 'vue'
import { useRouter } from 'vue-router'

import { useAuthStore } from '@/stores/authStore'

const router = useRouter()
const authStore = useAuthStore()

watchEffect(() => {
  if (authStore.isFetched && authStore.user !== null) {
    router.back()
  }
})
</script>

<template>
  <RouterView />
</template>
