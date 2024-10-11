<script setup>
import Chart from 'chart.js/auto'
import { onMounted, ref } from 'vue'

import ChartBar from './ChartBar.vue'
</script>

<template>
  <div class="rounded-md bg-zinc-100 p-4 shadow">
    <ChartBar />
  </div>
</template>
