<script setup>
import { format } from 'date-fns'
import { Eye, Loader2 } from 'lucide-vue-next'
import { onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableEmpty,
  TableHead,
  TableHeader,
  TableRow
} from '@/components/ui/table'

import { buttonVariants } from '../ui/button'

const route = useRoute()

const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)

const formattedDate = date => format(new Date(date), 'dd/MM/yyyy HH:mm:ss')

const getWorkingTimes = async userId => {
  workingTimesLoading.value = true
  workingTimesError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${userId}?order_by=start&order=desc`
    )

    workingTimes.value = result.data
  } catch {
    workingTimesError.value = `Failed to fetch WorkingTimes`
  } finally {
    workingTimesLoading.value = false
  }
}

watch(() => route.params.userId, getWorkingTimes)
onMounted(() => {
  getWorkingTimes(route.params.userId)
})
</script>

<template>
  <div class="rounded-md bg-zinc-100 p-4 shadow">
    <div v-if="workingTimesLoading" class="flex items-center gap-x-2">
      <Loader2 class="size-4 animate-spin" />
      <span>Loading...</span>
    </div>
    <div v-else-if="workingTimesError">
      {{ workingTimesError }}
    </div>

    <Table v-else>
      <TableEmpty v-if="workingTimes.length === 0" :colspan="2">
        No working time
      </TableEmpty>

      <TableCaption>The list of working times.</TableCaption>

      <TableHeader>
        <TableRow>
          <TableHead>Start</TableHead>
          <TableHead>End</TableHead>
          <TableHead />
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="workingTime in workingTimes" :key="workingTime.id">
          <TableCell>{{ formattedDate(workingTime.start) }}</TableCell>
          <TableCell>{{ formattedDate(workingTime.end) }}</TableCell>

          <TableCell>
            <RouterLink
              :to="{
                name: 'working-time',
                params: {
                  userId: route.params.userId,
                  workingTimeId: workingTime.id
                }
              }"
              :class="buttonVariants({ size: 'iconXs', variant: 'none' })"
            >
              <Eye class="size-5" />
            </RouterLink>
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>
  </div>
</template>
