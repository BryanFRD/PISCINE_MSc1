<script setup>
import { CalendarDate } from '@internationalized/date'
import { toTypedSchema } from '@vee-validate/zod'
import { format } from 'date-fns'
import { Edit3, Loader2 } from 'lucide-vue-next'
import { useForm } from 'vee-validate'
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { toast } from 'vue-sonner'
import { z } from 'zod'

import { instance } from '@/api/instance'
import { AutoForm } from '@/components/ui/auto-form'
import { Button } from '@/components/ui/button'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from '@/components/ui/dialog'

const route = useRoute()

const isOpen = ref(false)
const isLoading = ref(false)

const props = defineProps({
  workingTime: { type: Object, required: true },
  onSuccess: { type: Function, default: () => {} }
})

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

    await instance.put(`/workingtimes/${route.params.workingTimeId}`, body)

    props.onSuccess()
    isOpen.value = false

    toast.success('Working time updated successfully')
  } catch (result) {
    form.setErrors({
      startDate: result.response.data.errors.start,
      endDate: result.response.data.errors.end
    })
  } finally {
    isLoading.value = false
  }
}

watch(
  () => [props.workingTime, isOpen.value],
  () => {
    const startDate = new Date(props.workingTime.start)
    const endDate = new Date(props.workingTime.end)

    form.setValues({
      startDate: new CalendarDate(
        startDate.getFullYear(),
        startDate.getMonth() + 1,
        startDate.getDate()
      ),
      startTime: format(new Date(props.workingTime.start), 'HH:mm:ss'),
      endDate: new CalendarDate(
        endDate.getFullYear(),
        endDate.getMonth() + 1,
        endDate.getDate()
      ),
      endTime: format(new Date(props.workingTime.end), 'HH:mm:ss')
    })
  }
)
</script>

<template>
  <Dialog v-model:open="isOpen">
    <DialogTrigger as-child>
      <slot />
    </DialogTrigger>

    <DialogContent>
      <DialogHeader>
        <DialogTitle>Edit the working time</DialogTitle>
        <DialogDescription>
          Fill out the form below to edit the working time.
        </DialogDescription>
      </DialogHeader>

      <AutoForm
        class="space-y-6 py-4"
        :schema="schema"
        :form="form"
        @submit="onSubmit"
      >
        <DialogFooter>
          <Button type="submit" :disabled="isLoading">
            <Loader2 v-if="isLoading" class="size-4 animate-spin" />
            <Edit3 v-else class="size-4" />
            <span>Update</span>
          </Button>
        </DialogFooter>
      </AutoForm>
    </DialogContent>
  </Dialog>
</template>
