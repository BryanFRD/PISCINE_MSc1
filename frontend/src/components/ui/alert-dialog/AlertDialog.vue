<script setup>
import { AlertDialogRoot, useForwardPropsEmits } from 'radix-vue'

const props = defineProps({
  open: { type: Boolean },
  defaultOpen: { type: Boolean }
})
const emits = defineEmits(['update:open'])

const forwarded = useForwardPropsEmits(props, emits)
</script>

<template>
  <AlertDialogRoot v-bind="forwarded">
    <slot />
  </AlertDialogRoot>
</template>
