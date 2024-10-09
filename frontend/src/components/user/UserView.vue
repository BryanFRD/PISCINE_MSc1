<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { instance } from '../../api/instance'
import { Loader2, User2, Plus, Edit3, Trash2, Undo } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import CreateUserDialog from './CreateUserDialog.vue'
import EditUserDialog from './EditUserDialog.vue'
import DeleteUserDialog from './DeleteUserDialog.vue'

const route = useRoute()

const user = ref({
  id: null,
  username: null,
  email: null
})
const userLoading = ref(false)
const userError = ref(null)

const getUser = async userId => {
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
  <div class="mx-auto my-2 w-full max-w-xl">
    <div class="rounded-md bg-zinc-100 p-4 shadow">
      <div v-if="userLoading" class="flex items-center gap-x-2">
        <Loader2 class="size-4 animate-spin" />
        <span>Loading...</span>
      </div>

      <div v-else-if="userError">
        {{ userError }}
      </div>

      <div v-else class="flex items-center gap-x-4">
        <div
          class="flex size-10 items-center justify-center rounded-full bg-zinc-200"
        >
          <User2 class="size-6" />
        </div>

        <div>
          <h1 class="text-lg font-semibold leading-6">
            {{ user.username }}
          </h1>
          <p class="text-sm leading-6 text-zinc-500">
            {{ user.email }}
          </p>
        </div>
      </div>

      <Separator class="my-4" />

      <div class="flex items-center gap-x-2">
        <CreateUserDialog>
          <Button size="xs">
            <Plus class="size-4" />
            <span>Create a user</span>
          </Button>
        </CreateUserDialog>

        <EditUserDialog
          :user="user"
          :on-success="() => getUser(route.params.userId)"
        >
          <Button size="xs">
            <Edit3 class="size-4" />
            <span>Edit the user</span>
          </Button>
        </EditUserDialog>

        <DeleteUserDialog>
          <Button size="xs" variant="destructive">
            <Trash2 class="size-4" />
            <span>Delete the user</span>
          </Button>
        </DeleteUserDialog>
      </div>
    </div>
  </div>
</template>
