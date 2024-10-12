<script setup>
import { ref } from 'vue'

import ChartBar from './ChartBar.vue'
import ChartDonut from './chartDonut.vue'
import ChartLine from './ChartLine.vue'

const barError = ref(false)
const donutError = ref(false)
const lineError = ref(false)
</script>

<template>
  <div class="rounded-md bg-zinc-100 p-4 shadow">
    <div v-if="!barError & !donutError & !lineError" class="tqt">
      <ChartBar @error="barError = true" />
      <ChartDonut @error="donutError = true" />
      <ChartLine @error="lineError = true" />
    </div>

    <div v-else>
      <h1>Erreur</h1>
    </div>
  </div>
</template>
