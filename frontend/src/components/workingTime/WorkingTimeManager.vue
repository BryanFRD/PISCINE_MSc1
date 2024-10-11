<script setup>
import { format } from 'date-fns'
import { Edit3, Loader2, Plus, Trash2 } from 'lucide-vue-next'
import { onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'
import { Button, buttonVariants } from '@/components/ui/button'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from '@/components/ui/table'

import DeleteWorkingTimeDialog from './DeleteWorkingTimeDialog.vue'
import EditWorkingTimeDialog from './EditWorkingTimeDialog.vue'

const route = useRoute()

const workingTime = ref({
  id: null,
  start: null,
  end: null
})

const workingTimeLoading = ref(false)
const workingTimeError = ref(null)

const workingTimeInitialized = ref(false)

const getWorkingTime = async (userId, workingTimeId) => {
  workingTimeLoading.value = true
  workingTimeError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${userId}/${workingTimeId}`
    )

    workingTime.value = result.data
  } catch {
    workingTimeError.value = 'Failed to fetch working time'
  } finally {
    workingTimeLoading.value = false
  }
}

watch(
  () => [route.params.userId, route.params.workingTimeId],
  values => {
    getWorkingTime(values[0], values[1])
  }
)
onMounted(() => {
  getWorkingTime(route.params.userId, route.params.workingTimeId)
})
</script>

<template>
  <div class="rounded-md bg-zinc-100 p-4 shadow">
    <div
      v-if="workingTimeLoading && !workingTimeInitialized"
      class="flex items-center gap-x-2"
    >
      <Loader2 class="size-4 animate-spin" />
      <span>Loading...</span>
    </div>

    <div v-else-if="workingTimeError">
      {{ workingTimeError }}
    </div>

    <div v-else>
      <h2 class="mb-2 text-xl font-semibold">Working Time Manager</h2>

      <Table class="mb-4">
        <TableHeader>
          <TableRow>
            <TableHead class="text-center">Start</TableHead>
            <TableHead class="text-center">End</TableHead>
          </TableRow>
        </TableHeader>

        <TableBody>
          <TableRow>
            <TableCell class="text-center">
              {{
                format(
                  new Date(workingTime.start),
                  'MMMM dd, yyyy hh:mm:ss aaa'
                )
              }}
            </TableCell>
            <TableCell class="text-center">
              {{
                format(new Date(workingTime.end), 'MMMM dd, yyyy hh:mm:ss aaa')
              }}
            </TableCell>
          </TableRow>
        </TableBody>
      </Table>

      <div class="flex items-center gap-x-2">
        <RouterLink
          :to="{
            name: 'working-time-create',
            params: { userId: route.params.id }
          }"
          :class="buttonVariants({ size: 'xs' })"
        >
          <Plus class="size-4" />
          <span>Create a working time</span>
        </RouterLink>

        <EditWorkingTimeDialog
          :working-time="workingTime"
          :on-success="
            () =>
              getWorkingTime(route.params.userId, route.params.workingTimeId)
          "
        >
          <Button size="xs">
            <Edit3 class="size-4" />
            <span>Edit</span>
          </Button>
        </EditWorkingTimeDialog>

        <DeleteWorkingTimeDialog>
          <Button size="xs" variant="destructive">
            <Trash2 class="size-4" />
            <span>Delete</span>
          </Button>
        </DeleteWorkingTimeDialog>
      </div>
    </div>
  </div>
</template>
