<script setup>
import { toTypedSchema } from '@vee-validate/zod'
import { Loader2 } from 'lucide-vue-next'
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
  user: { type: Object, required: true },
  onSuccess: { type: Function, default: () => {} }
})

const schema = z.object({
  username: z.string().min(3).max(255),
  email: z.string().email()
})

const form = useForm({
  validationSchema: toTypedSchema(schema)
})

const onSubmit = async values => {
  isLoading.value = true

  try {
    await instance.put(`/users/${route.params.userId}`, values)

    props.onSuccess()
    isOpen.value = false

    toast.success('User updated successfully')
  } catch (result) {
    form.setErrors(result.response.data.errors)
  } finally {
    isLoading.value = false
  }
}

watch(
  () => [props.user, isOpen.value],
  () => form.setValues(props.user)
)
</script>

<template>
  <Dialog v-model:open="isOpen">
    <DialogTrigger as-child>
      <slot />
    </DialogTrigger>

    <DialogContent>
      <DialogHeader>
        <DialogTitle>Edit the user</DialogTitle>
        <DialogDescription>
          Fill out the form below to edit the user.
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
            <span>Update</span>
          </Button>
        </DialogFooter>
      </AutoForm>
    </DialogContent>
  </Dialog>
</template>
