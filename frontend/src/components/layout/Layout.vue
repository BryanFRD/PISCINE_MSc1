<script setup>
import { User2 } from 'lucide-vue-next'
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import { Button } from '@/components/ui/button'
import UserDropdown from '@/components/user/UserDropdown.vue'

const route = useRoute()

const userId = computed(() => route.params.userId)

const routeNames = [
  { name: 'clock', label: 'Clock' },
  { name: 'working-times', label: 'Working Times' },
  { name: 'chart-manager', label: 'Charts' }
]
</script>

<template>
  <div class="fixed inset-x-0 top-0 z-40 w-full px-4 backdrop-blur-md">
    <header class="mx-auto flex h-14 w-full max-w-5xl items-center gap-x-4">
      <h3 class="text-lg font-semibold">TimeManager</h3>

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
              params: { userId: userId || 1 }
            }"
          >
            {{ routeName.label }}
          </RouterLink>
        </Button>
      </nav>

      <UserDropdown v-if="userId !== undefined">
        <template #trigger>
          <Button size="iconXs" variant="ghost" class="rounded-full">
            <User2 class="size-5" />
          </Button>
        </template>
      </UserDropdown>
    </header>
  </div>

  <div class="mx-auto w-full max-w-5xl px-4 pb-10 pt-20">
    <RouterView />
  </div>
</template>
