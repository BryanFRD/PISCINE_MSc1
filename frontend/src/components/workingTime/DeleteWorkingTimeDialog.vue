<script setup>
import { Loader2 } from 'lucide-vue-next'
import { ref } from 'vue'
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

const props = defineProps({
  workingTimeId: {
    type: Number,
    required: true
  }
})

const isOpen = ref(false)
const isLoading = ref(false)

const submit = async () => {
  isLoading.value = true

  try {
    await instance.delete(`/workingtimes/${props.workingTimeId}`)

    isOpen.value = false
  } catch {
    toast.error('Failed to delete working time')
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
        <AlertDialogTitle>Delete Working Time</AlertDialogTitle>
        <AlertDialogDescription>
          Are you sure you want to delete this working time?
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
