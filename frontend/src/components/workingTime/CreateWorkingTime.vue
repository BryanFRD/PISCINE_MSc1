<script setup>
import { toTypedSchema } from '@vee-validate/zod'
import { Edit3, Loader2 } from 'lucide-vue-next'
// import moment from 'moment'
import { useForm } from 'vee-validate'
import { ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { z } from 'zod'

import { instance } from '@/api/instance'
import { AutoForm } from '@/components/ui/auto-form'
import { Button } from '@/components/ui/button'

const route = useRoute()
const router = useRouter()

const isOpen = ref(false)
const isLoading = ref(false)

const schema = z.object({
  startDate: z.coerce.date(),
  startTime: z.string().time(),
  endDate: z.coerce.date(),
  endTime: z.string().time()
})

const form = useForm({
  validationSchema: toTypedSchema(schema)
})

const onSubmit = async values => {
  isLoading.value = true

  try {
    const start = new Date(values.startDate)
    const startTime = values.startTime.split(':')
    start.setHours(startTime[0])
    start.setMinutes(startTime[1])
    start.setSeconds(startTime[2])

    const end = new Date(values.endDate)
    const endTime = values.endTime.split(':')
    end.setHours(endTime[0])
    end.setMinutes(endTime[1])
    end.setSeconds(endTime[2])

    const body = {
      start: start.toISOString(),
      end: end.toISOString()
    }

    const result = await instance.post(
      `/workingtimes/${route.params.userId}`,
      body
    )

    router.push(`working-time/${route.params.userId}/${result.data.id}`)

    isOpen.value = false
    toast.success('Working time created successfully')
  } catch (result) {
    form.setErrors({
      startDate: result.response.data.errors.start,
      endDate: result.response.data.errors.end
    })
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <h2 class="text-xl font-semibold">New Working Time</h2>

  <AutoForm
    :field-config="{
      startTime: {
        inputProps: {
          placeholder: 'hh:mm:ss'
        }
      },
      endTime: {
        inputProps: {
          placeholder: 'hh:mm:ss'
        }
      }
    }"
    class="space-y-6"
    :schema="schema"
    :form="form"
    @submit="onSubmit"
  >
    <Button type="submit" :disabled="isLoading">
      <Loader2 v-if="isLoading" class="size-4 animate-spin" />
      <Edit3 v-else class="size-4" />
      <span>Create</span>
    </Button>
  </AutoForm>
</template>
