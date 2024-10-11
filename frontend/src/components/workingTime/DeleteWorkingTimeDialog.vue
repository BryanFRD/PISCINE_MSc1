<script setup>
import { Loader2 } from 'lucide-vue-next'
import { ref } from 'vue'
import { useRoute } from 'vue-router'

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
const workingTimeError = ref(null)

const props = defineProps({
  workingTime: { type: Object, required: true },
  onSuccess: { type: Function, default: () => {} }
})

const deleteWorkingTime = async workingTimeId => {
  console.log('FUNCTION')
  try {
    const result = await instance.delete(`/workingtimes/${workingTimeId}`)
  } catch (err) {
    console.log(err)
    workingTimeError.value = err.message
  }
  if (!workingTimeError.value) {
    props.onSuccess()
    isOpen.value = false
  }
}

const button = () => {
  console.log('Button ok is calling')
}

const closeDialog = () => {
  isOpen.value = false
}
</script>

<template>
  <AlertDialog v-model:open="isOpen">
    <AlertDialogTrigger as-child>
      <slot />
    </AlertDialogTrigger>

    <AlertDialogContent>
      <AlertDialogHeader>
        <AlertDialogTitle>Delete the working time</AlertDialogTitle>
      </AlertDialogHeader>
      <AlertDialogFooter>
        <Button
          :disabled="isLoading"
          @click="deleteWorkingTime(props.workingTime.id)"
        >
          <Loader2 v-if="isLoading" class="size-4 animate-spin" />
          <span>Confirm</span>
        </Button>
        <Button :disabled="isLoading" @click="closeDialog()">
          <Loader2 v-if="isLoading" class="size-4 animate-spin" />
          <span>Cancel</span>
        </Button>
      </AlertDialogFooter>
    </AlertDialogContent>
  </AlertDialog>
</template>

<style>
.errorMsg {
  color: red;
}
</style>
