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
import { Button, buttonVariants } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import { useAuthStore } from '@/stores/authStore'

const router = useRouter()
const authStore = useAuthStore()

const isLoading = ref(false)

const schema = z.object({
  email: z.string().email().max(160),
  password: z.string().min(12).max(72)
})

const form = useForm({
  validationSchema: toTypedSchema(schema)
})

const onSubmit = async values => {
  isLoading.value = true

  try {
    const result = await instance.post('/auth/login', values)

    localStorage.setItem('time-manager-token', result.data.token)
    authStore.user = result.data.user

    router.push({ name: 'home' })

    toast.success('Logged in successfully')
  } catch (result) {
    form.setErrors(result.response.data.errors)
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="grid h-screen grid-cols-2">
    <div class="hidden bg-primary lg:block" />

    <div class="col-span-2 flex items-center lg:col-span-1">
      <div class="mx-auto w-full max-w-xl space-y-6 px-4">
        <h1 class="text-3xl font-bold">Login to your account</h1>

        <AutoForm
          class="space-y-6"
          :schema="schema"
          :form="form"
          :field-config="{
            password: {
              inputProps: {
                type: 'password'
              }
            }
          }"
          @submit="onSubmit"
        >
          <Button type="submit" :disabled="isLoading">
            <Loader2 v-if="isLoading" class="size-4 animate-spin" />
            <span>Login</span>
          </Button>
        </AutoForm>

        <Separator label="Or" />

        <RouterLink
          :to="{ name: 'register' }"
          :class="buttonVariants({ variant: 'outline' })"
          class="w-full"
        >
          Create an account
        </RouterLink>
      </div>
    </div>
  </div>
</template>
