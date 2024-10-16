<script setup>
import {
  CategoryScale,
  Chart as ChartJS,
  Legend,
  LinearScale,
  LineElement,
  PointElement,
  Title,
  Tooltip
} from 'chart.js'
import {
  differenceInMinutes,
  endOfToday,
  format,
  getDate,
  startOfMonth
} from 'date-fns'
import { enUS } from 'date-fns/locale'
import { Loader2 } from 'lucide-vue-next'
import { computed, onMounted, ref, watch } from 'vue'
import { Line } from 'vue-chartjs'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'

const route = useRoute()
const firstMonthDay = startOfMonth(new Date())
const today = endOfToday()
const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)
const getWorkingTimes = async userId => {
  workingTimesLoading.value = true
  workingTimesError.value = null
  try {
    const result = await instance.get(
      `/workingtimes/${userId}?order_by=start&order=asc&start=${firstMonthDay.toISOString()}&end=${today.toISOString()}`
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
  format(new Date(date), 'MM/dd', { locale: enUS })

//for the chart label's
const daysOfMonth = () => {
  const days = []
  const daysInMonth = getDate(today)
  for (let i = 1; i <= daysInMonth; i++) {
    days.push(
      formattedDateToDay(
        new Date(new Date().getFullYear(), new Date().getMonth(), i)
      )
    )
  }
  return days
}

const workHoursPerDay = computed(() => {
  const daysInMonth = getDate(today)
  const hours = Array(daysInMonth).fill(0)

  workingTimes.value.forEach(time => {
    const startDate = new Date(time.start)
    const endDate = new Date(time.end)
    const dayIndex = startDate.getDate() - 1
    const minutesWorked = differenceInMinutes(endDate, startDate)
    hours[dayIndex] += minutesWorked / 60
  })

  return hours
})

const labels = daysOfMonth()

const chartData = computed(() => ({
  labels,
  datasets: [
    {
      label: 'Monthly Working Hours',
      data: workHoursPerDay.value,
      backgroundColor: 'rgba(0, 0, 0, 0.300)',
      borderColor: 'rgba(0,0,0)',
      borderWidth: 1.5
    }
  ]
}))

const chartOptions = {
  responsive: true,
  maintainAspectRatio: true,
  plugins: {
    legend: {
      display: false,
      position: 'top'
    }
  },
  scales: {
    x: {
      title: {
        display: true,
        text: 'Day'
      }
    },
    y: {
      title: {
        display: true,
        text: 'Hours'
      },
      beginAtZero: true
    }
  }
}

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
)

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
      Month Working Time
    </h1>

    <Line :data="chartData" :options="chartOptions" />
  </div>
</template>
