<script setup>
import { format } from 'date-fns'
import { Eye, Plus } from 'lucide-vue-next'
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'
import { buttonVariants } from '@/components/ui/button'
import { Skeleton } from '@/components/ui/skeleton'
import {
  Table,
  TableBody,
  TableCell,
  TableEmpty,
  TableHead,
  TableHeader,
  TableRow
} from '@/components/ui/table'

const route = useRoute()

const userId = computed(() => route.params.userId)

const workingTimes = ref([])
const workingTimesLoading = ref(false)
const workingTimesError = ref(null)

const formatDate = date => format(new Date(date), 'MMMM dd, yyyy hh:mm:ss aa')

const getWorkingTimes = async () => {
  workingTimesLoading.value = true
  workingTimesError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${userId.value}?order_by=start&order=desc`
    )

    workingTimes.value = result.data
  } catch {
    workingTimesError.value = `Failed to fetch WorkingTimes`
  } finally {
    workingTimesLoading.value = false
  }
}

watch(
  () => userId.value,
  () => getWorkingTimes()
)
onMounted(() => getWorkingTimes())
</script>

<template>
  <div v-if="workingTimesLoading" class="space-y-4">
    <Skeleton class="h-10 w-1/2" />
    <Skeleton class="h-40 w-full" />
  </div>

  <div v-else-if="workingTimesError">
    {{ workingTimesError }}
  </div>

  <template v-else>
    <div class="mb-4 flex items-center justify-between">
      <h1 class="text-3xl font-bold">Working Times</h1>

      <RouterLink
        :to="{
          name: 'working-time-create',
          params: { userId }
        }"
        :class="buttonVariants({ size: 'sm' })"
      >
        <Plus class="size-4" />
        <span>Create</span>
      </RouterLink>
    </div>

    <Table>
      <TableEmpty v-if="workingTimes.length === 0" :colspan="3">
        No working time
      </TableEmpty>

      <TableHeader>
        <TableRow>
          <TableHead class="font-semibold">#</TableHead>
          <TableHead>Start</TableHead>
          <TableHead>End</TableHead>
          <TableHead />
        </TableRow>
      </TableHeader>
      <TableBody>
        <TableRow v-for="workingTime in workingTimes" :key="workingTime.id">
          <TableCell class="font-semibold">{{ workingTime.id }}</TableCell>
          <TableCell>{{ formatDate(workingTime.start) }}</TableCell>
          <TableCell>{{ formatDate(workingTime.end) }}</TableCell>

          <TableCell>
            <RouterLink
              :to="{
                name: 'working-time',
                params: { userId, workingTimeId: workingTime.id }
              }"
              :class="buttonVariants({ size: 'iconXs', variant: 'secondary' })"
            >
              <Eye class="size-5" />
            </RouterLink>
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>
  </template>
</template>
