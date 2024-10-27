<script setup>
import { Eye, Loader2, Pencil, Plus, Trash2 } from 'lucide-vue-next'
import { computed, onMounted, ref, watch } from 'vue'
import { useRouter } from 'vue-router'

import { instance } from '@/api/instance'
import { Button } from '@/components/ui/button'
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from '@/components/ui/table'
import { useAuthStore } from '@/stores/authStore'

import CreateUserDialog from '../user/CreateUserDialog.vue'

const userLoading = ref(false)
const userError = ref(null)
const userF = ref([])

const router = useRouter()

const getUser = async () => {
  userLoading.value = true
  userError.value = null
  try {
    const result = await instance.get(`/users/`)
    userF.value = result.data
  } catch {
    userError.value = `Failed to fetch user`
  } finally {
    userLoading.value = false
  }
}

const authStore = useAuthStore()
watch(() => getUser())
onMounted(() => {
  getUser()
})
</script>

<template>
  <h1 class="text-3xl font-bold">Users</h1>

  <div class="flex justify-end">
    <CreateUserDialog>
      <Button>
        <Plus class="size-4" />
        <span>Create a user</span>
      </Button>
    </CreateUserDialog>
  </div>

  <div class="mt-4">
    <p v-if="userLoading">Chargement en cours...</p>
    <p v-if="userError">{{ userError }}</p>
    <Table v-else>
      <TableCaption> Users</TableCaption>

      <TableHeader>
        <TableRow>
          <TableHead>Username</TableHead>
          <TableHead>Email</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="user in userF" :key="user.id">
          <TableCell>{{ user.username }}</TableCell>
          <TableCell>{{ user.email }}</TableCell>
          <TableCell>
            <Button
              variant="ghost"
              @click="() => router.push(`/chart-manager/${user.id}`)"
            >
              <Eye class="size-4" />
            </Button>
            <Button
              variant="ghost"
              @click="() => router.push(`/account/${user.id}`)"
            >
              <Pencil class="size-4" />
            </Button>
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>
  </div>
</template>
