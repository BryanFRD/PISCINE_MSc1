<script setup>
import { differenceInMinutes, endOfToday, startOfToday } from 'date-fns'
import { computed, onMounted, ref, watch } from 'vue'

import { instance } from '@/api/instance'
import { DonutChart } from '@/components/ui/chart-donut'

const props = defineProps({
  userId: {
    type: Number,
    required: true
  }
})

const startToday = startOfToday()
const endToday = endOfToday()

const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)

const getWorkingTimes = async () => {
  workingTimesLoading.value = true
  workingTimesError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${props.userId}?order_by=start&order=asc&start=${startToday.toISOString()}&end=${endToday.toISOString()}`
    )

    workingTimes.value = result.data
  } catch {
    workingTimesError.value = `Failed to fetch WorkingTimes`
  } finally {
    workingTimesLoading.value = false
  }
}

const data = computed(() => {
  let lastEndDate = null

  const hours = workingTimes.value.reduce(
    (acc, workingTime) => {
      const startDate = new Date(workingTime.start)
      const endDate = new Date(workingTime.end)

      if (lastEndDate) {
        const breakTime = differenceInMinutes(lastEndDate, startDate)
        acc.break += breakTime
      }

      acc.work += differenceInMinutes(endDate, startDate)

      lastEndDate = endDate

      return acc
    },
    { work: 0, break: 0 }
  )

  return [
    {
      name: 'Work',
      Hours: Math.round(hours.work / 60)
    },
    {
      name: 'Break',
      Hours: Math.round(hours.break / 60)
    }
  ]
})

watch(
  () => props.userId,
  () => getWorkingTimes()
)
onMounted(() => getWorkingTimes())
</script>

<template>
  <div>
    <h2 class="mb-4 text-2xl font-bold">Today Work Chart</h2>

    <DonutChart
      :data="data"
      index="name"
      :category="'Hours'"
      :value-formatter="value => `${value}h`"
    />
  </div>
</template>
