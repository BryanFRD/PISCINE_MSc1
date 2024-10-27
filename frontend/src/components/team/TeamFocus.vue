<script setup>
import { onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'

import CalandarWorkForAll from '../chartManager/CalandarWorkForAll.vue'
import ChartBar from '../chartManager/ChartBar.vue'

const route = useRoute()
const loading = ref(true)
const error = ref(null)
const team = ref(null)

const getTeamDetails = async teamId => {
  loading.value = true
  error.value = null
  try {
    const result = await instance.get(`/teams/${teamId}`)
    team.value = result.data
  } catch (err) {
    error.value = `Failed to fetch team`
  } finally {
    loading.value = false
  }
}

watch(
  () => route.params.teamId,
  teamId => {
    getTeamDetails(teamId)
  }
)

onMounted(() => {
  const teamId = route.params.teamId
  getTeamDetails(teamId)
})
</script>

<template>
  <p v-if="loading">Chargement des détails de l'équipe...</p>
  <p v-if="error">{{ error }}</p>
  <div v-if="team">
    <h2 class="text-3xl font-bold">{{ team.name }}</h2>
    <div class="flex">
      <div class="w-1/2 pr-4">
        <h3 class="mt-4 text-xl font-bold">Managers</h3>
        <ul>
          <li v-for="manager in team.managers" :key="manager.id">
            {{ manager.username }} ({{ manager.email }})
          </li>
        </ul>
      </div>

      <div class="w-1/2 pl-4">
        <h3 class="mt-4 text-xl font-bold">Users</h3>
        <ul>
          <li v-for="user in team.users" :key="user.id">
            {{ user.username }} ({{ user.email }})
          </li>
        </ul>
      </div>
    </div>

    <div class="col-span-2 m-4 rounded-lg p-4 shadow">
      <div class="w-full">
        <CalandarWorkForAll />
      </div>
    </div>
  </div>
</template>
