<script setup>
import { add, format, isSameDay } from 'date-fns'
import { enUS } from 'date-fns/locale'
import { DatePicker } from 'v-calendar'
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'

import 'v-calendar/style.css'

const route = useRoute()
const wkTs = ref([])
const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)

const getWorkingTimes = async userId => {
  workingTimesLoading.value = true
  workingTimesError.value = null

  try {
    const result = await instance.get(`/workingtimes/${userId}`)
    workingTimes.value = result.data
  } catch {
    workingTimesError.value = `Failed to fetch WorkingTimes`
  } finally {
    workingTimesLoading.value = false
  }
}

const formatWorkingTimeForCalendar = workingTimes => {
  if (!Array.isArray(workingTimes)) {
    console.error('workingTimes is not an array:', workingTimes)
    return []
  }

  const colors = ['red', 'blue', 'yellow', 'green', 'purple', 'black', 'purple']
  return workingTimes.map((item, index) => ({
    key: item.id,
    dot: true,
    dates: new Date(item.start),
    description: `${item.user.username}'s work: ${format(new Date(item.start), 'HH:mm')} - ${format(new Date(item.end), 'HH:mm')}`,
    color: colors[index % colors.length]
  }))
}

const attrs = computed(() => [
  ...wkTs.value.map(wkT => ({
    dates: wkT.dates,
    dot: {
      color: wkT.color
    },
    popover: {
      label: wkT.description
    }
  }))
])

const today = ref(new Date())
const formattedDateToDay = date =>
  format(new Date(date), 'eeee MM/dd', { locale: enUS })

const workingTimesForDay = computed(() =>
  wkTs.value.filter(wkT => isSameDay(wkT.dates, today.value))
)

watch(
  () => route.params.userId,
  userId => {
    getWorkingTimes(userId)
  },
  { immediate: true }
)

onMounted(() => {
  const userId = route.params.userId
  getWorkingTimes(userId).then(() => {
    wkTs.value = formatWorkingTimeForCalendar(workingTimes.value)
  })
})
</script>
<template>
  <div class="flex justify-between">
    <div class="left w-1/2">
      <DatePicker
        v-model:model-value="today"
        expanded
        :attributes="attrs"
        locale="en"
      />
    </div>

    <div class="right w-1/2">
      <div v-if="workingTimesForDay.length">
        <h2 class="mb-4 text-2xl font-bold">
          WorkingTimes for {{ formattedDateToDay(today) }}
        </h2>
        <ul>
          <li v-for="(wkT, index) in workingTimesForDay" :key="index">
            <span :style="{ color: wkT.color }">•</span> {{ wkT.description }}
          </li>
        </ul>
      </div>
      <div v-else>
        <h2 class="mb-4 text-2xl font-bold">No workingTimes for this day.</h2>
      </div>
    </div>
  </div>
</template>
