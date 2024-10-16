<script setup>
import { format } from 'date-fns'
import { Loader2 } from 'lucide-vue-next'
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { toast } from 'vue-sonner'

import { instance } from '@/api/instance'
import { Button } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'

const route = useRoute()

const userId = computed(() => route.params.userId)

const clock = ref({
  id: null,
  time: null,
  status: false
})

const clockLoading = ref(false)
const clockError = ref(null)
const clockInitialized = ref(false)

const getClock = async () => {
  clockLoading.value = true
  clockError.value = null

  try {
    const result = await instance.get(`/clocks/${userId.value}`)

    clock.value = result.data
    clockInitialized.value = true
  } catch {
    clockError.value = 'Failed to fetch clock'
  } finally {
    clockLoading.value = false
  }
}

const submitClockLoading = ref(false)

const submitClock = async () => {
  submitClockLoading.value = true

  try {
    await instance.put(`/clocks/${userId.value}`, {
      status: !clock.value.status,
      time: new Date().toISOString()
    })

    getClock(userId)

    toast.success('Clock submitted')

    if (clock.value.status) {
      submitWorkingTime(clock.value.time, new Date())
    }
  } catch {
    toast.error('Failed to submit clock')
  } finally {
    submitClockLoading.value = false
  }
}

const submitWorkingTime = async (start, end) => {
  try {
    await instance.post(`/workingtimes/${userId.value}`, {
      start: new Date(start).toISOString(),
      end: new Date(end).toISOString()
    })

    toast.success('Working time submitted')
  } catch {
    toast.error('Failed to submit working time')
  }
}

watch(
  () => userId.value,
  () => getClock()
)
onMounted(() => getClock())
</script>

<template>
  <div v-if="clockLoading && !clockInitialized" class="space-y-4">
    <Skeleton class="h-10 w-1/2" />
    <Skeleton class="h-6 w-1/3" />
    <Skeleton class="h-6 w-1/4" />
    <Skeleton class="h-10 w-full" />
  </div>

  <div v-else-if="clockError">
    {{ clockError }}
  </div>

  <div v-else>
    <h1 class="mb-4 text-3xl font-bold">Clock manager</h1>

    <p v-if="!clock.time">You haven't clocked in yet</p>
    <div v-else class="space-y-2">
      <p>
        Last clock:
        {{ format(new Date(clock.time), 'MMMM dd, yyyy hh:mm:ss aa') }}
      </p>

      <p>Status: {{ clock.status ? 'Clocked in' : 'Clocked out' }}</p>
    </div>

    <Button
      class="mt-4 w-full"
      :disabled="submitClockLoading"
      @click="submitClock"
    >
      <Loader2 v-if="submitClockLoading" class="size-4 animate-spin" />
      <span>
        {{ clock.status ? 'Clock out' : 'Clock in' }}
      </span>
    </Button>
  </div>
</template>
