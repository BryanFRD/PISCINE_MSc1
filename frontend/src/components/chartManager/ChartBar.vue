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
import { differenceInMinutes, format, subDays } from 'date-fns'
import { enUS } from 'date-fns/locale'
import { computed, onMounted, ref, watch } from 'vue'
import { Bar } from 'vue-chartjs'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

const route = useRoute()
const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)

const getWorkingTimes = async userId => {
  workingTimesLoading.value = true
  workingTimesError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${userId}?order_by=start&order=asc&start=${subDays(new Date(), 7).toISOString()}&end=${new Date().toISOString()}`
    )
    workingTimes.value = result.data
  } catch {
    workingTimesError.value = `Failed to fetch WorkingTimes`
  } finally {
    workingTimesLoading.value = false
  }
}

const formattedDateToDay = date =>
  format(new Date(date), 'eeee', { locale: enUS })

const lastDaysName = () => {
  const daysList = []
  for (let i = 0; i < 7; i++) {
    const currentDay = subDays(new Date(), i)
    daysList.push(formattedDateToDay(currentDay))
  }
  return daysList.reverse()
}

const workHoursPerDay = computed(() => {
  const hours = Array(7).fill(0)
  workingTimes.value.forEach(time => {
    const startDate = new Date(time.start)
    const endDate = new Date(time.end)
    const dayIndex = startDate.getDay()

    const minutesWorked = differenceInMinutes(endDate, startDate)
    hours[dayIndex] += minutesWorked
  })
  return hours
})

const labels = lastDaysName()

const chartData = computed(() => ({
  labels,
  datasets: [
    {
      label: 'Working Hours For The Last 7 Day',
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
  <div>
    <p>{{ workHoursPerDay }}</p>
    <Bar :data="chartData" :options="chartOptions" />
  </div>
</template>

<style scoped>
canvas {
  max-width: 600px;
  max-height: 400px;
}
</style>
