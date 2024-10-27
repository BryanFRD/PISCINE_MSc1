<script setup>
import { Eye, Loader2, Plus, Trash2 } from 'lucide-vue-next'
import { onMounted, ref } from 'vue'
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

const router = useRouter()
const loading = ref(false)
const error = ref(null)
const teams = ref([])

const getTeams = async () => {
  loading.value = true
  error.value = null
  try {
    const result = await instance.get(`/teams/`)
    teams.value = result.data
  } catch {
    error.value = `Failed to fetch teams`
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  getTeams()
})
</script>

<template>
  <div>
    <h1 class="text-3xl font-bold">Teams</h1>

    <p v-if="loading">Chargement en cours...</p>
    <p v-if="error">{{ error }}</p>
    <Table v-else>
      <TableCaption> Teams</TableCaption>

      <TableHeader>
        <TableRow>
          <TableHead>Team Name</TableHead>
          <TableHead>Managers</TableHead>
          <TableHead>Users</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="team in teams" :key="team.id">
          <TableCell>{{ team.name }}</TableCell>
          <TableCell>
            <ul>
              <li v-for="manager in team.managers" :key="manager.id">
                {{ manager.username }} ({{ manager.email }})
              </li>
            </ul>
          </TableCell>
          <TableCell>
            <ul>
              <li v-for="user in team.users" :key="user.id">
                {{ user.username }} ({{ user.email }})
              </li>
            </ul>
          </TableCell>
          <TableCell>
            <Button
              variant="ghost"
              @click="() => router.push(`/team-focus/${team.id}`)"
            >
              <Eye class="size-4" />
            </Button>
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>
  </div>
</template>
