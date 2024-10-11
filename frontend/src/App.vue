<script setup>
import { Toaster } from '@/components/ui/sonner'
</script>

<template>
  <div class="mx-auto my-2 w-full max-w-xl space-y-4">
    <RouterView />
  </div>

  <Toaster />
</template>
