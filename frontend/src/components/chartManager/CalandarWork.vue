<script setup>
import { add, differenceInMinutes, format, subDays } from 'date-fns'
import { Calendar, DatePicker } from 'v-calendar'
import { ref } from 'vue'

import 'v-calendar/style.css'

const dm = add(new Date(), { days: 1 })

const attrs = ref([
  {
    key: 'today',
    dot: true,
    content: 'red',
    dates: new Date()
  }
])
const date = ref(dm)
</script>

<template>
  <div>
    <DatePicker v-model:modelValue="date" expanded :attributes="attrs" />
  </div>
</template>
