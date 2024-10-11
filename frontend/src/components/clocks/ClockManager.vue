<script setup>
import { format } from 'date-fns'
import { Loader2 } from 'lucide-vue-next'
import { onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { toast } from 'vue-sonner'

import { instance } from '@/api/instance'
import { Button } from '@/components/ui/button'

const route = useRoute()

const clock = ref({
  id: null,
  time: null,
  status: false
})

const clockLoading = ref(false)
const clockError = ref(null)
const clockInitialized = ref(false)

const getClock = async userId => {
  clockLoading.value = true
  clockError.value = null

  try {
    const result = await instance.get(`/clocks/${userId}`)

    clock.value = result.data
    clockInitialized.value = true
  } catch {
    clockError.value = 'Failed to fetch clock'
  } finally {
    clockLoading.value = false
  }
}

const submitClockLoading = ref(false)
const submitClockError = ref(null)

const submitClock = async userId => {
  submitClockLoading.value = true
  submitClockError.value = null

  try {
    await instance.put(`/clocks/${userId}`, {
      status: !clock.value.status,
      time: new Date().toISOString()
    })

    getClock(userId)

    toast.success('Clock submitted')
  } catch {
    submitClockError.value = 'Failed to submit clock'
  } finally {
    submitClockLoading.value = false
  }
}

watch(() => route.params.userId, getClock)
onMounted(() => {
  getClock(route.params.userId)
})
</script>

<template>
  <div class="rounded-md bg-zinc-100 p-4 shadow">
    <div
      v-if="clockLoading && !clockInitialized"
      class="flex items-center gap-x-2"
    >
      <Loader2 class="size-4 animate-spin" />
      <span>Loading...</span>
    </div>

    <div v-else-if="clockError">
      {{ clockError }}
    </div>

    <div v-else>
      <h2 class="mb-2 text-xl font-semibold">Clock manager</h2>

      <p v-if="!clock.time">You haven't clocked in yet</p>
      <div v-else class="space-y-2">
        <p>
          Last clock: {{ format(new Date(clock.time), 'dd/MM/yyyy hh:mm:ss') }}
        </p>

        <p>Status: {{ clock.status ? 'Clocked in' : 'Clocked out' }}</p>
      </div>

      <Button
        class="mt-4 w-full"
        :disabled="submitClockLoading"
        @click="submitClock(route.params.userId)"
      >
        <Loader2 v-if="submitClockLoading" class="size-4 animate-spin" />
        <span>
          {{ clock.status ? 'Clock out' : 'Clock in' }}
        </span>
      </Button>
    </div>
  </div>
</template>
