<script setup>
import { Loader2 } from 'lucide-vue-next'
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import { toast } from 'vue-sonner'

import { instance } from '@/api/instance'
import {
  AlertDialog,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger
} from '@/components/ui/alert-dialog'
import { Button } from '@/components/ui/button'

const route = useRoute()

const isOpen = ref(false)
const isLoading = ref(false)

const submit = async () => {
  isLoading.value = true

  try {
    await instance.delete(`/users/${route.params.userId}`)

    isOpen.value = false
  } catch {
    toast.error('Failed to delete user')
  } finally {
    isLoading.value = false
  }
}
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
        <Button :disabled="isLoading" @click="submit">
          <Loader2 v-if="isLoading" class="size-4 animate-spin" />
          <span>Continue</span>
        </Button>
      </AlertDialogFooter>
    </AlertDialogContent>
  </AlertDialog>
</template>
