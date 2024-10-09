<script setup>
import { computed } from 'vue'
import { Label } from 'radix-vue'
import { cn } from '@/lib/utils'

const props = defineProps({
  for: { type: String, default: null },
  asChild: { type: Boolean },
  class: { type: String, default: null }
})

const delegatedProps = computed(() => {
  const { class: _, ...delegated } = props

  return delegated
})
</script>

<template>
  <Label
    v-bind="delegatedProps"
    :class="
      cn(
        'text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70',
        props.class
      )
    "
  >
    <slot />
  </Label>
</template>
