<script setup>
import { DialogRoot, useForwardPropsEmits } from 'radix-vue'

const props = defineProps({
  open: { type: Boolean },
  defaultOpen: { type: Boolean },
  modal: { type: Boolean }
})
const emits = defineEmits(['update:open'])

const forwarded = useForwardPropsEmits(props, emits)
</script>

<template>
  <DialogRoot v-bind="forwarded">
    <slot />
  </DialogRoot>
</template>
