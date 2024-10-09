<script setup>
import { DialogTrigger } from 'radix-vue'

const props = defineProps({
  asChild: { type: Boolean },
  as: { type: null, default: undefined }
})
</script>

<template>
  <DialogTrigger v-bind="props">
    <slot />
  </DialogTrigger>
</template>
