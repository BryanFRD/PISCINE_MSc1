<script setup>
import { DialogClose } from 'radix-vue'

const props = defineProps({
  asChild: { type: Boolean },
  as: { type: null, default: undefined }
})
</script>

<template>
  <DialogClose v-bind="props">
    <slot />
  </DialogClose>
</template>
