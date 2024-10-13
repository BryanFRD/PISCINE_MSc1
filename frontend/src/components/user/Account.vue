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
import { Skeleton } from '@/components/ui/skeleton'

import CreateUserDialog from './CreateUserDialog.vue'
import DeleteUserDialog from './DeleteUserDialog.vue'

const route = useRoute()

const userId = computed(() => route.params.userId)

// Get user
const user = ref({
  id: null,
  username: null,
  email: null
})
const userLoading = ref(false)
const userError = ref(null)

const userInitialized = ref(false)

const getUser = async () => {
  userLoading.value = true
  userError.value = null

  try {
    const result = await instance.get(`/users/${userId.value}`)

    user.value = result.data
    userInitialized.value = true
  } catch {
    userError.value = 'Failed to fetch user'
  } finally {
    userLoading.value = false
  }
}

watch(
  () => userId.value,
  () => getUser()
)
onMounted(() => getUser())

// Update user
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
    await instance.put(`/users/${userId.value}`, values)

    getUser()

    toast.success('User updated successfully')
  } catch (result) {
    form.setErrors(result.response.data.errors)
  } finally {
    isLoading.value = false
  }
}

watch(
  () => user.value,
  () => form.setValues(user.value)
)
</script>

<template>
  <h1 class="mb-4 text-3xl font-bold">Account</h1>

  <div v-if="userLoading && !userInitialized" class="space-y-6">
    <Skeleton class="h-10 w-full" />
    <Skeleton class="h-10 w-full" />
    <Skeleton class="h-10 w-28" />
  </div>

  <div v-else-if="userError">
    {{ userError }}
  </div>

  <template v-else>
    <AutoForm
      class="space-y-6"
      :schema="schema"
      :form="form"
      @submit="onSubmit"
    >
      <Button type="submit" :disabled="isLoading">
        <Loader2 v-if="isLoading" class="size-4 animate-spin" />
        <span>Update my account</span>
      </Button>
    </AutoForm>

    <Separator class="mb-4 mt-8" />

    <h3 class="mb-4 text-2xl font-semibold">Actions</h3>

    <div class="flex items-center gap-x-2">
      <CreateUserDialog>
        <Button>
          <Plus class="size-4" />
          <span>Create a user</span>
        </Button>
      </CreateUserDialog>

      <DeleteUserDialog :user-id="parseInt(userId)">
        <Button variant="destructive">
          <Trash2 class="size-4" />
          <span>Delete my account</span>
        </Button>
      </DeleteUserDialog>
    </div>
  </template>
</template>
