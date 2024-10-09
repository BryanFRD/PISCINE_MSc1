<script setup>
import { ref, watch } from 'vue'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger
} from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { Input } from '@/components/ui/input'
import { instance } from '@/api/instance'
import { useRoute, useRouter } from 'vue-router'
import { Loader2 } from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()

const isOpen = ref(false)

const props = defineProps({
  user: { type: Object, required: true },
  onSuccess: { type: Function, default: () => {} }
})

const attributes = ref({
  username: '',
  email: ''
})

const submitLoading = ref(false)
const submitError = ref(null)

const submit = async () => {
  submitLoading.value = true
  submitError.value = null

  try {
    await instance.put(`/users/${route.params.userId}`, attributes.value)

    props.onSuccess()
    isOpen.value = false
  } catch (result) {
    submitError.value = result.response.data.errors
  } finally {
    submitLoading.value = false
  }
}

watch(isOpen, value => {
  if (value) {
    attributes.value = {
      username: props.user.username,
      email: props.user.email
    }

    submitLoading.value = false
    submitError.value = null
  }
})
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

      <div class="grid gap-y-6 py-4">
        <div class="grid gap-y-2">
          <Label for="username">Username</Label>
          <Input
            id="username"
            v-model="attributes.username"
            type="text"
            class="col-span-3"
          />

          <p
            v-if="submitError?.username"
            class="text-sm font-medium text-destructive"
          >
            Username {{ submitError.username[0] }}
          </p>
        </div>

        <div class="grid gap-y-2">
          <Label for="email">Email</Label>
          <Input id="email" v-model="attributes.email" type="email" />

          <p
            v-if="submitError?.email"
            class="text-sm font-medium text-destructive"
          >
            Email {{ submitError.email[0] }}
          </p>
        </div>
      </div>

      <DialogFooter>
        <Button :disabled="submitLoading" @click="submit">
          <Loader2 v-if="submitLoading" class="size-4 animate-spin" />
          <span>Update</span>
        </Button>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>
