<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import CalandarWork from './CalandarWork.vue'
import ChartBar from './ChartBar.vue'
import ChartDonut from './chartDonut.vue'
import ChartLine from './ChartLine.vue'
import MonthWorkChart from './MonthWorkChart.vue'
import TodayWorkChart from './TodayWorkChart.vue'
import WeekWorkChart from './WeekWorkChart.vue'

const route = useRoute()

const userId = computed(() => route.params.userId)
</script>

<template>
  <div class="space-y-16">
    <ChartDonut />
    <ChartBar />
    <ChartLine />
    <CalandarWork :user-id="parseInt(userId)" />
  </div>
</template>
