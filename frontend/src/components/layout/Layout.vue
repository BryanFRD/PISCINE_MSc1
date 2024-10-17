<script setup>
import { User2 } from 'lucide-vue-next'
import { computed, watchEffect } from 'vue'
import { useRouter } from 'vue-router'

import { Button, buttonVariants } from '@/components/ui/button'
import UserDropdown from '@/components/user/UserDropdown.vue'
import { useAuthStore } from '@/stores/authStore'

const router = useRouter()
const authStore = useAuthStore()

const user = computed(() => authStore.user)

const routeNames = [
  { name: 'clock', label: 'Clock' },
  { name: 'working-times', label: 'Working Times' },
  { name: 'chart-manager', label: 'Charts' }
]

watchEffect(() => {
  if (authStore.isFetched && !authStore.user) {
    router.replace({ name: 'login' })
  }
})
</script>

<template>
  <div class="fixed inset-x-0 top-0 z-40 w-full px-4 backdrop-blur-md">
    <header class="mx-auto flex h-14 w-full max-w-5xl items-center gap-x-4">
      <RouterLink :to="{ name: 'home' }" class="text-lg font-semibold">
        TimeManager
      </RouterLink>

      <nav class="flex flex-1 items-center gap-x-2">
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
              params: { userId: user?.id || 1 }
            }"
          >
            {{ routeName.label }}
          </RouterLink>
        </Button>
      </nav>

      <UserDropdown v-if="user !== null">
        <template #trigger>
          <Button size="iconXs" variant="ghost" class="rounded-full">
            <User2 class="size-5" />
          </Button>
        </template>
      </UserDropdown>

      <RouterLink
        v-else
        :to="{ name: 'login' }"
        :class="buttonVariants({ size: 'sm', variant: 'secondary' })"
      >
        Login
      </RouterLink>
    </header>
  </div>

  <div class="mx-auto w-full max-w-5xl px-4 pb-10 pt-20">
    <RouterView />
  </div>
</template>
