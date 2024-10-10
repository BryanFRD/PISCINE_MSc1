<script setup>
import { toTypedSchema } from '@vee-validate/zod'
import { Loader2 } from 'lucide-vue-next'
import { useForm } from 'vee-validate'
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { toast } from 'vue-sonner'
import { z } from 'zod'

import { instance } from '@/api/instance'
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
const workingTimeError = ref(null)

const props = defineProps({
  workingTime: { type: Object, required: true },
  onSuccess: { type: Function, default: () => {} }
})

const deleteWorkingTime = async workingTimeId => {
  try {
    const result = await instance.delete(`/workingtimes/${workingTimeId}`)
  } catch (err) {
    console.log(err)
    workingTimeError.value = 'Failed to update this working time.'
  }
  if (!workingTimeError.value) {
    props.onSuccess()
    isOpen.value = false
  }
}

const closeDialog = () => {
  isOpen.value = false
}
</script>

<template>
  <Dialog v-model:open="isOpen">
    <DialogTrigger as-child>
      <slot />
    </DialogTrigger>

    <DialogContent>
      <DialogHeader>
        <DialogTitle>Delete the working time</DialogTitle>
      </DialogHeader>
      <DialogFooter>
        <Button
          :click="deleteWorkingTime(props.workingTime.id)"
          :disabled="isLoading"
        >
          <Loader2 v-if="isLoading" class="size-4 animate-spin" />
          <span>Confirm</span>
        </Button>
        <Button :click="closeDialog()" :disabled="isLoading">
          <Loader2 v-if="isLoading" class="size-4 animate-spin" />
          <span>Cancel</span>
        </Button>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>

<style>
.errorMsg {
  color: red;
}
</style>
