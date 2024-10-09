<script setup>
import { AlertDialogTrigger } from 'radix-vue'

const props = defineProps({
  asChild: { type: Boolean },
  as: { type: null, default: undefined }
})
</script>

<template>
  <AlertDialogTrigger v-bind="props">
    <slot />
  </AlertDialogTrigger>
</template>
