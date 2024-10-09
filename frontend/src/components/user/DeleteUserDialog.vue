<script setup>
import { ref, watch } from 'vue'
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger
} from '@/components/ui/alert-dialog'
import { Button } from '@/components/ui/button'
import { instance } from '@/api/instance'
import { useRoute, useRouter } from 'vue-router'
import { Loader2 } from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()

const isOpen = ref(false)

const submitLoading = ref(false)
const submitError = ref(null)

const submit = async () => {
  submitLoading.value = true
  submitError.value = null

  try {
    await instance.delete(`/users/${route.params.userId}`)

    isOpen.value = false
  } catch (result) {
    submitError.value = result.response.data.errors
  } finally {
    submitLoading.value = false
  }
}

watch(isOpen, value => {
  if (value) {
    submitLoading.value = false
    submitError.value = null
  }
})
</script>

<template>
  <AlertDialog v-model:open="isOpen">
    <AlertDialogTrigger as-child>
      <slot />
    </AlertDialogTrigger>

    <AlertDialogContent>
      <AlertDialogHeader>
        <AlertDialogTitle>Delete User</AlertDialogTitle>
        <AlertDialogDescription>
          Are you sure you want to delete this user?
        </AlertDialogDescription>
      </AlertDialogHeader>

      <AlertDialogFooter>
        <AlertDialogCancel>Cancel</AlertDialogCancel>
        <Button :disabled="submitLoading" @click="submit">
          <Loader2 v-if="submitLoading" class="size-4 animate-spin" />
          <span>Continue</span>
        </Button>
      </AlertDialogFooter>
    </AlertDialogContent>
  </AlertDialog>
</template>
