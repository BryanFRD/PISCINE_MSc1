<script setup>
import { useRoute } from 'vue-router'

import UserView from '@/components/user/User.vue'

import { Button } from '../ui/button'

const route = useRoute()

const routeNames = [
  { name: 'clock', label: 'Clock' },
  { name: 'working-times', label: 'Working Times' }
]
</script>

<template>
  <div class="fixed inset-x-0 top-0 z-40 w-full px-4 backdrop-blur-md">
    <header class="mx-auto flex h-14 w-full max-w-4xl items-center gap-x-4">
      <h3 class="text-lg font-semibold">TimeManager</h3>

      <nav class="flex items-center gap-x-2">
        <Button
          v-for="routeName in routeNames"
          :key="routeName.name"
          as-child
          size="none"
          variant="link"
        >
          <RouterLink
            :to="{
              name: routeName.name,
              params: { userId: route.params.userId }
            }"
          >
            {{ routeName.label }}
          </RouterLink>
        </Button>
      </nav>
    </header>
  </div>

  <div class="mx-auto w-full max-w-2xl space-y-4 px-4 pb-10 pt-16">
    <UserView />

    <RouterView />
  </div>
</template>
