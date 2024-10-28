<script setup>
import { add, format, isSameDay } from 'date-fns'
import { enUS } from 'date-fns/locale'
import { DatePicker } from 'v-calendar'
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'

import 'v-calendar/style.css'

const route = useRoute()
const wkTs = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)
const users = ref([])
const userColors = ref({})

const getTeamDetails = async teamId => {
  try {
    const result = await instance.get(`/teams/${teamId}`)
    users.value = result.data.users
  } catch {
    workingTimesError.value = `Failed to fetch team details`
  }
}

const getWorkingTimes = async userId => {
  try {
    const result = await instance.get(
      `/workingtimes/${userId}?order_by=start&order=asc`
    )
    return result.data
  } catch {
    workingTimesError.value = `Failed to fetch working times for user ${userId}`
    return []
  }
}

const fetchAllWorkingTimes = async () => {
  const allWorkingTimes = []
  for (const user of users.value) {
    const workingTimes = await getWorkingTimes(user.id)
    allWorkingTimes.push(...workingTimes)
  }
  return allWorkingTimes
}

const assignUserColors = () => {
  const colors = ['red', 'blue', 'yellow', 'green', 'purple', 'orange', 'pink']
  users.value.forEach((user, index) => {
    userColors.value[user.id] = colors[index % colors.length]
  })
}

const formatWorkingTimeForCalendar = workingTimes => {
  if (!Array.isArray(workingTimes)) {
    return []
  }

  return workingTimes.map(item => ({
    key: item.id,
    dot: true,
    dates: new Date(item.start),
    description: `${item.user.username}'s work: ${format(new Date(item.start), 'HH:mm')} - ${format(new Date(item.end), 'HH:mm')}`,
    color: userColors.value[item.user.id] || 'black'
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

onMounted(async () => {
  const teamId = route.params.teamId
  await getTeamDetails(teamId)
  assignUserColors()
  const allWorkingTimes = await fetchAllWorkingTimes()
  wkTs.value = formatWorkingTimeForCalendar(allWorkingTimes)
})
</script>

<template>
  <div class="flex justify-between space-x-10">
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
          Working Times for {{ formattedDateToDay(today) }}
        </h2>
        <ul>
          <li v-for="(wkT, index) in workingTimesForDay" :key="index">
            <span :style="{ color: wkT.color }">•</span> {{ wkT.description }}
          </li>
        </ul>
      </div>
      <div v-else>
        <h2 class="mb-4 text-2xl font-bold">No working times for this day.</h2>
      </div>
    </div>
  </div>
</template>
