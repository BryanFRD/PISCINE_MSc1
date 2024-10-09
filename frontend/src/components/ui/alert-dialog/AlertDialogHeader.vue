<script setup>
import { cn } from '@/lib/utils'

const props = defineProps({
  class: { type: String, default: null }
})
</script>

<template>
  <div
    :class="cn('flex flex-col gap-y-2 text-center sm:text-left', props.class)"
  >
    <slot />
  </div>
</template>
