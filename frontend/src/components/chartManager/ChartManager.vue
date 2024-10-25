<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import CalandarWork from './CalandarWork.vue'
import ChartBar from './ChartBar.vue'
import ChartDonut from './chartDonut.vue'
import ChartLine from './ChartLine.vue'

const route = useRoute()

const userId = computed(() => route.params.userId)
</script>

<template>
  <div class="grid grid-cols-2 gap-6 p-6">
    <div
      class="col-span-1 flex flex-col items-center rounded-lg bg-white p-4 shadow"
    >
      <ChartDonut />
    </div>

    <div class="col-span-1 items-center rounded-lg bg-white p-2 shadow">
      <ChartBar />
    </div>

    <div class="col-span-2 items-center rounded-lg bg-white p-4 shadow">
      <ChartLine />
    </div>

    <div class="col-span-2 flex rounded-lg p-4 shadow">
      <div class="w-full">
        <CalandarWork :user-id="parseInt(userId)" />
      </div>
    </div>
  </div>
</template>
