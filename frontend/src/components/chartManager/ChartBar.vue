<script setup>
import {
  BarElement,
  CategoryScale,
  Chart as ChartJS,
  Legend,
  LinearScale,
  Title,
  Tooltip
} from 'chart.js'
import { add, differenceInMinutes, format, subDays } from 'date-fns'
import { enUS } from 'date-fns/locale'
import { Loader2 } from 'lucide-vue-next'
import { computed, onMounted, ref, watch } from 'vue'
import { Bar } from 'vue-chartjs'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)
// chart bar who whow last seven day working hour
const route = useRoute()
const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)
const dm = add(new Date(), { days: 1 })
const getWorkingTimes = async userId => {
  workingTimesLoading.value = true
  workingTimesError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${userId}?order_by=start&order=asc&start=${subDays(new Date(), 7).toISOString()}&end=${dm.toISOString()}`
    )
    workingTimes.value = result.data
  } catch {
    workingTimesError.value = `Failed to fetch WorkingTimes`
  } finally {
    workingTimesLoading.value = false
  }
}
//only have  the name and Month/day
const formattedDateToDay = date =>
  format(new Date(date), 'eeee MM/dd', { locale: enUS })

//for the chart label's
const lastDaysName = () => {
  const daysList = []
  for (let i = 0; i < 7; i++) {
    const currentDay = subDays(new Date(), i)
    daysList.push(formattedDateToDay(currentDay))
  }
  return daysList.reverse()
}
//to accumulate working hours per day
const workHoursPerDay = computed(() => {
  const hours = Array(7).fill(0)
  workingTimes.value.forEach(time => {
    const startDate = new Date(time.start)
    const endDate = new Date(time.end)
    const dayIndex = startDate.getDay()
    const minutesWorked = differenceInMinutes(endDate, startDate)
    hours[dayIndex] += minutesWorked / 60
  })
  return hours
})

const labels = lastDaysName()
//chart params
const chartData = computed(() => ({
  labels,
  datasets: [
    {
      label: 'Working Hours For The Last 7 Days',
      data: workHoursPerDay.value,
      backgroundColor: 'rgba(0, 0, 0, 0.300)',
      borderColor: 'rgba(0,0,0)',
      borderWidth: 1.5
    }
  ]
}))

const chartOptions = {
  responsive: true,
  scales: {
    y: {
      title: {
        display: true,
        text: 'Hours'
      },
      beginAtZero: true
    }
  }
}

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

  <div v-else>
    <h1 style="text-align: center; margin-bottom: 10px; font-weight: bold">
      Working Hours For The Last 7 Days
    </h1>
    <Bar :data="chartData" :options="chartOptions"></Bar>
  </div>
</template>
