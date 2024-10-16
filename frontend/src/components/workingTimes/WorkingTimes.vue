<script setup>
import { Plus } from 'lucide-vue-next'
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import { buttonVariants } from '@/components/ui/button'

import DataTable from './table/data-table.vue'

const route = useRoute()

const userId = computed(() => parseInt(route.params.userId))
</script>

<template>
  <div class="mb-4 flex items-center justify-between">
    <h1 class="text-3xl font-bold">Working Times</h1>

    <RouterLink
      :to="{
        name: 'working-time-create',
        params: { userId }
      }"
      :class="buttonVariants({ size: 'sm' })"
    >
      <Plus class="size-4" />
      <span>Create</span>
    </RouterLink>
  </div>

  <DataTable :user-id="userId" />
</template>
