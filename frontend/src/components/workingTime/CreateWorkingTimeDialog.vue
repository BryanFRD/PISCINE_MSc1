<script setup>
import { toTypedSchema } from '@vee-validate/zod'
import { Loader2 } from 'lucide-vue-next'
import moment from 'moment'
import { useForm } from 'vee-validate'
import { ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
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
const router = useRouter()

const isOpen = ref(false)
const isLoading = ref(false)
const workingTimeError = ref(null)

const defaultValues = ref(null)

const props = defineProps({
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

const createWorkingTime = async userId => {
  console.log(form.values)
  const body = {
    start: `${form.values.startDay} ${form.values.startTime}`,
    end: `${form.values.endDay} ${form.values.endTime}`
  }
  let result = null
  try {
    result = await instance.post(`/workingtimes/${userId}`, body)
  } catch (err) {
    console.log(err)
    workingTimeError.value = 'Failed to create a working time.'
  }
  if (!workingTimeError.value) {
    router.push(`/${userId}/${result.data.id}`)
    props.onSuccess()
    isOpen.value = false
  }
}
</script>

<template>
  <Dialog v-model:open="isOpen">
    <DialogTrigger as-child>
      <slot />
    </DialogTrigger>

    <DialogContent>
      <DialogHeader>
        <DialogTitle>Create new working time</DialogTitle>
        <DialogDescription>
          Fill out the form below to create a new working time.
        </DialogDescription>
      </DialogHeader>

      <AutoForm
        :field-config="{
          startDay: {
            inputProps: {
              placeholder: 'YYYY-MM-DD'
            }
          },
          startTime: {
            inputProps: {
              placeholder: 'HH:MM:SS'
            }
          },
          endDay: {
            inputProps: {
              placeholder: 'YYYY-MM-DD'
            }
          },
          endTime: {
            inputProps: {
              placeholder: 'HH:MM:SS'
            }
          }
        }"
        class="space-y-6 py-4"
        :schema="schema"
        :form="form"
        @submit="createWorkingTime(route.params.userId)"
      >
        <div class="errorMsg" :if="workingTimeError">
          {{ workingTimeError }}
        </div>
        <DialogFooter>
          <Button type="submit" :disabled="isLoading">
            <Loader2 v-if="isLoading" class="size-4 animate-spin" />
            <span>Create</span>
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
