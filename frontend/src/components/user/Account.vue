<script setup>
import { toTypedSchema } from '@vee-validate/zod'
import { Loader2, Plus, Trash2 } from 'lucide-vue-next'
import { useForm } from 'vee-validate'
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { toast } from 'vue-sonner'
import { z } from 'zod'

import { instance } from '@/api/instance'
import { AutoForm } from '@/components/ui/auto-form'
import { Button } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import { useAuthStore } from '@/stores/authStore'

import CreateUserDialog from './CreateUserDialog.vue'
import DeleteUserDialog from './DeleteUserDialog.vue'

const authStore = useAuthStore()
const route = useRoute()

const user = computed(() => authStore.user)
const userF = ref([])
const isLoading = ref(false)
const userLoading = ref(false)
const userError = ref(null)
const schema = z.object({
  email: z.string().email().max(160),
  username: z.string().min(3).max(30),
  password: z.string().min(12).max(72).optional(),
  password_confirmation: z.string().min(12).max(72).optional()
})

const form = useForm({
  validationSchema: toTypedSchema(schema)
})

const getUser = async userId => {
  userLoading.value = true
  userError.value = null
  try {
    const result = await instance.get(`/users/${userId}`)
    userF.value = result.data
  } catch {
    userError.value = `Failed to fetch user`
  } finally {
    userLoading.value = false
  }
}

const onSubmit = async values => {
  isLoading.value = true

  try {
    const result = await instance.put(`/users/${route.params.userId}`, values)

    authStore.user = result.data
    toast.success('User updated successfully')
  } catch (result) {
    form.setErrors(result.response.data.errors)
  } finally {
    isLoading.value = false
  }
}

watch(
  () => userF.value,
  () => form.setValues(userF.value)
)
onMounted(() => {
  getUser(route.params.userId)
  if (userF.value) {
    form.setValues(userF.value)
  }
})
</script>

<template>
  <h1 class="mb-4 text-3xl font-bold">Account</h1>

  <AutoForm
    class="space-y-6"
    :schema="schema"
    :form="form"
    :field-config="{
      password: {
        label: 'New password',
        inputProps: {
          type: 'password'
        }
      },
      password_confirmation: {
        label: 'Password confirmation',
        inputProps: {
          type: 'password'
        }
      }
    }"
    @submit="onSubmit"
  >
    <Button type="submit" :disabled="isLoading">
      <Loader2 v-if="isLoading" class="size-4 animate-spin" />
      <span>Update account</span>
    </Button>
  </AutoForm>

  <div v-if="authStore?.user?.role === 'admin'">
    <Separator class="mb-4 mt-8" />

    <h3 class="mb-4 text-2xl font-semibold">Actions</h3>

    <div class="flex items-center gap-x-2">
      <DeleteUserDialog v-if="user" :user-id="user.id">
        <Button variant="destructive">
          <Trash2 class="size-4" />
          <span>Delete this account</span>
        </Button>
      </DeleteUserDialog>
    </div>
  </div>
</template>
