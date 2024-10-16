<script setup>
import {
  differenceInMinutes,
  endOfDay,
  format,
  isSameDay,
  startOfDay,
  subDays
} from 'date-fns'
import { computed, onMounted, ref, watch } from 'vue'

import { instance } from '@/api/instance'
import { BarChart } from '@/components/ui/chart-bar'

const props = defineProps({
  userId: {
    type: Number,
    required: true
  }
})

const lastWeekDate = subDays(new Date(), 7)

const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)

const getWorkingTimes = async () => {
  workingTimesLoading.value = true
  workingTimesError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${props.userId}?order_by=start&order=asc&start=${lastWeekDate.toISOString()}`
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
    let lastEndDate = null

    const hours = value.reduce(
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

    return {
      date: format(new Date(key), 'yyyy-MM-dd'),
      Work: Math.round(hours.work / 60),
      Break: Math.round(hours.break / 60)
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
    <h2 class="mb-4 text-2xl font-bold">Weekly Work Chart</h2>

    <BarChart
      :data="data"
      index="date"
      :categories="['Work', 'Break']"
      show-x-axis
      :rounded-corners="4"
      :y-formatter="value => `${value}h`"
    />
  </div>
</template>
