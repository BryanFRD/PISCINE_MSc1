<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { instance } from '../api/instance'
import { Loader2 } from 'lucide-vue-next'

const route = useRoute()

const user = ref({
  id: null,
  username: null,
  email: null
})
const userLoading = ref(false)
const userError = ref(null)

const getUser = async (userId) => {
  userLoading.value = true
  userError.value = null

  try {
    const result = await instance.get(`/users/${userId}`)

    user.value = result.data
  } catch {
    userError.value = 'Failed to fetch user'
  } finally {
    userLoading.value = false
  }
}

watch(() => route.params.userId, getUser)
onMounted(() => {
  getUser(route.params.userId)
})
</script>

<template>
  <div class="max-w-xl w-full mx-auto my-2">
    <div class="bg-zinc-100 shadow rounded-md p-4">
      <div
        v-if="userLoading"
        class="flex items-center gap-x-2"
      >
        <Loader2 class="animate-spin size-4" />
        <span>Loading...</span>
      </div>
  
      <div v-else-if="userError">
        {{ userError }}
      </div>
  
      <div v-else>
        <h1 class="text-lg font-semibold">
          {{ user.username }}
        </h1>
        <p class="text-sm text-zinc-600">
          {{ user.email }}
        </p>
      </div>
    </div>
  </div>
</template>
