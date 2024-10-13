<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'

import MonthWorkChart from './MonthWorkChart.vue'
import TodayWorkChart from './TodayWorkChart.vue'
import WeekWorkChart from './WeekWorkChart.vue'

const route = useRoute()

const userId = computed(() => route.params.userId)
</script>

<template>
  <div class="space-y-16">
    <TodayWorkChart :user-id="parseInt(userId)" />
    <WeekWorkChart :user-id="parseInt(userId)" />
    <MonthWorkChart :user-id="parseInt(userId)" />
  </div>
</template>
