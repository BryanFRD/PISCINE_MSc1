<script setup>
import {
  differenceInMinutes,
  endOfDay,
  endOfMonth,
  format,
  isSameDay,
  startOfDay,
  startOfMonth
} from 'date-fns'
import { computed, onMounted, ref, watch } from 'vue'

import { instance } from '@/api/instance'
import { LineChart } from '@/components/ui/chart-line'

const props = defineProps({
  userId: {
    type: Number,
    required: true
  }
})

const startMonth = startOfMonth(new Date())
const endMonth = endOfMonth(new Date())

const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)

const getWorkingTimes = async () => {
  workingTimesLoading.value = true
  workingTimesError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${props.userId}?order_by=start&order=asc&start=${startMonth.toISOString()}&end=${endMonth.toISOString()}`
    )

    workingTimes.value = result.data
  } catch {
    workingTimesError.value = `Failed to fetch WorkingTimes`
  } finally {
    workingTimesLoading.value = false
  }
}

const groupedWorkingTimes = computed(() => {
  if (!workingTimes.value.length) return {}

  return workingTimes.value.reduce((acc, workingTime) => {
    const startDate = new Date(workingTime.start)
    const endDate = new Date(workingTime.end)

    if (isSameDay(startDate, endDate)) {
      const startDay = startOfDay(startDate)
      const dateISOString = startDay.toISOString()

      if (!acc[dateISOString]) {
        acc[dateISOString] = []
      }

      acc[dateISOString].push(workingTime)
    } else {
      const startDay = startOfDay(startDate)
      const endDay = endOfDay(startDate)

      const dateISOString = startDay.toISOString()

      if (!acc[dateISOString]) {
        acc[dateISOString] = []
      }

      acc[dateISOString].push({
        ...workingTime,
        end: endDay.toISOString()
      })

      const nextDay = startOfDay(endDate)
      const nextDayISOString = nextDay.toISOString()

      if (!acc[nextDayISOString]) {
        acc[nextDayISOString] = []
      }

      acc[nextDayISOString].push({
        ...workingTime,
        start: nextDay.toISOString()
      })
    }

    return acc
  }, {})
})

const data = computed(() => {
  return Object.entries(groupedWorkingTimes.value).map(([key, value]) => {
    const hours = value.reduce(
      (acc, workingTime) => {
        const startDate = new Date(workingTime.start)
        const endDate = new Date(workingTime.end)

        acc.work += differenceInMinutes(endDate, startDate)

        return acc
      },
      { work: 0, break: 0 }
    )

    return {
      date: format(new Date(key), 'yyyy-MM-dd'),
      Work: Math.round(hours.work / 60)
    }
  })
})

watch(
  () => props.userId,
  () => getWorkingTimes()
)
onMounted(() => getWorkingTimes())
</script>

<template>
  <div>
    <h2 class="mb-4 text-2xl font-bold">Monthly Work Chart</h2>

    <LineChart
      :data="data"
      index="date"
      :categories="['Work']"
      show-grid-line
      :y-formatter="value => `${value}h`"
    />
  </div>
</template>
