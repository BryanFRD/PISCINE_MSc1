<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import MonthWorkChart from './MonthWorkChart.vue'
import TodayWorkChart from './TodayWorkChart.vue'
import WeekWorkChart from './WeekWorkChart.vue'
import CalandarWork from './CalandarWork.vue'
import ChartDonut from './chartDonut.vue'
import ChartBar from './ChartBar.vue'
import ChartLine from './ChartLine.vue'

const route = useRoute()

const userId = computed(() => route.params.userId)
</script>

<template>
  <div class="space-y-16">
    <TodayWorkChart :user-id="parseInt(userId)" />
    <ChartDonut />
    <WeekWorkChart :user-id="parseInt(userId)" />
    <ChartBar />
    <MonthWorkChart :user-id="parseInt(userId)" />
    <ChartLine />
    <CalandarWork :user-id="parseInt(userId)" />
  </div>
</template>
