<script setup>
import { toTypedSchema } from '@vee-validate/zod'
import { Loader2 } from 'lucide-vue-next'
import { useForm } from 'vee-validate'
import { ref } from 'vue'
import { useRouter } from 'vue-router'
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

const router = useRouter()

const isOpen = ref(false)
const isLoading = ref(false)

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
    const result = await instance.post('/users', values)

    router.replace({
      params: { userId: result.data.id }
    })

    isOpen.value = false
    toast.success('User created successfully')
  } catch (result) {
    form.setErrors(result.response.data.errors)
  } finally {
    isLoading.value = false
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
        <DialogTitle> Create a user </DialogTitle>
        <DialogDescription>
          Fill out the form below to create a new user.
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
            <span>Submit</span>
          </Button>
        </DialogFooter>
      </AutoForm>
    </DialogContent>
  </Dialog>
</template>
