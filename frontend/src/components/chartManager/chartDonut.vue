<script setup>
import { differenceInMinutes, endOfDay, startOfDay } from 'date-fns'
import { Loader2 } from 'lucide-vue-next'
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'
import { DonutChart } from '@/components/ui/chart-donut'

const totalHoursToday = 1
// donut bar who show break time and working time form the current day

const route = useRoute()
const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)

const getWorkingTimes = async userId => {
  workingTimesLoading.value = true
  workingTimesError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${userId}?order_by=start&order=asc&start=${startOfDay(new Date()).toISOString()}&end=${endOfDay(new Date()).toISOString()}`
    )
    workingTimes.value = result.data
  } catch {
    workingTimesError.value = `Failed to fetch WorkingTimes`
  } finally {
    workingTimesLoading.value = false
  }
}

//return worktime and breaktime
const workAndBreakTimes = computed(() => {
  if (workingTimes.value.length === 0) return { workingTime: 0, breakTime: 0 }
  let totalWorkedMinutes = 0

  let earliestStart = null
  let latestEnd = null
  workingTimes.value.forEach(time => {
    const startTime = new Date(time.start)
    const endTime = new Date(time.end)

    if (!earliestStart || startTime < earliestStart) {
      earliestStart = startTime
    }
    if (!latestEnd || endTime > latestEnd) {
      latestEnd = endTime
    }

    totalWorkedMinutes += differenceInMinutes(endTime, startTime)
  })

  const workingTime = totalWorkedMinutes / 60

  const totalDayMinutes = differenceInMinutes(latestEnd, earliestStart)

  const breakMinutes = totalDayMinutes - totalWorkedMinutes
  const breakTime = breakMinutes / 60

  return {
    workingTime,
    breakTime
  }
})

const valueFormatter = value => `${value} hours`

watch(() => route.params.userId, getWorkingTimes)
onMounted(() => {
  getWorkingTimes(route.params.userId)
})
</script>

<template>
  <div v-if="workingTimesLoading" class="flex items-center gap-x-2">
    <Loader2 class="size-4 animate-spin" />
    <span>Loading...</span>
  </div>

  <div v-else-if="workingTimesError">
    <p>{{ workingTimesError }}</p>
  </div>

  <div v-else class="donuts">
    <h1 style="text-align: center; margin-bottom: 10px; font-weight: bold">
      Today Working Time
    </h1>
    <DonutChart
      index="name"
      :category="'total'"
      :data="[
        { name: 'Working Time', total: workAndBreakTimes.workingTime },
        { name: 'Break Time', total: workAndBreakTimes.breakTime }
      ]"
      :value-formatter="valueFormatter"
      :colors="['rgba(0,0,0,0.200)', 'rgba(230, 230, 230, 1)']"
    />
  </div>
</template>
