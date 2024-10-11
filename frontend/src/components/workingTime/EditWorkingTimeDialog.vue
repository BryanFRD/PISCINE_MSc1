<script setup>
import { toTypedSchema } from '@vee-validate/zod'
import { Loader2 } from 'lucide-vue-next'
import moment from 'moment'
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
const workingTimeError = ref(null)

const defaultValues = ref(null)

const props = defineProps({
  workingTime: { type: Object, required: true },
  onSuccess: { type: Function, default: () => {} }
})

const schema = z.object({
  startDay: z.string().date(),
  startTime: z.string().time(),
  endDay: z.string().date(),
  endTime: z.string().time()
})

const form = useForm({
  validationSchema: toTypedSchema(schema)
})

const updateWorkingTime = async workingTimeId => {
  console.log(form.values)
  const body = {
    start: `${form.values.startDay} ${form.values.startTime}`,
    end: `${form.values.endDay} ${form.values.endTime}`
  }
  try {
    const result = await instance.put(`/workingtimes/${workingTimeId}`, body)
  } catch (err) {
    console.log(err)
    workingTimeError.value = err.message
  }
  if (!workingTimeError.value) {
    props.onSuccess()
    isOpen.value = false
  }
}

const reassignValues = values => {
  defaultValues.value = {
    startDay: moment(values.start).format('YYYY-MM-DD'),
    startTime: moment(values.start).format('hh:mm:ss'),
    endDay: moment(values.end).format('YYYY-MM-DD'),
    endTime: moment(values.end).format('hh:mm:ss')
  }
}

watch(
  () => [props.workingTime, isOpen.value],
  async () => {
    await reassignValues(props.workingTime)
    await form.setValues(defaultValues.value)
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
        @submit="updateWorkingTime(props.workingTime.id)"
      >
        <div class="errorMsg" :if="workingTimeError">
          {{ workingTimeError }}
        </div>
        <DialogFooter>
          <Button type="submit" :disabled="isLoading">
            <Loader2 v-if="isLoading" class="size-4 animate-spin" />
            <span>Update</span>
          </Button>
        </DialogFooter>
      </AutoForm>
    </DialogContent>
  </Dialog>
</template>

<style>
.errorMsg {
  color: red;
}
</style>
