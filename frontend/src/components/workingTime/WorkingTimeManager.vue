<script setup>
import { format } from 'date-fns'
import { Edit3, Plus, Trash2 } from 'lucide-vue-next'
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

import { instance } from '@/api/instance'
import { Button, buttonVariants } from '@/components/ui/button'
import { Separator } from '@/components/ui/separator'
import { Skeleton } from '@/components/ui/skeleton'
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

const userId = computed(() => route.params.userId)
const workingTimeId = computed(() => route.params.workingTimeId)

const workingTime = ref({
  id: null,
  start: null,
  end: null
})

const workingTimeLoading = ref(false)
const workingTimeError = ref(null)

const workingTimeInitialized = ref(false)

const getWorkingTime = async () => {
  workingTimeLoading.value = true
  workingTimeError.value = null

  try {
    const result = await instance.get(
      `/workingtimes/${userId.value}/${workingTimeId.value}`
    )

    workingTime.value = result.data
  } catch {
    workingTimeError.value = 'Failed to fetch working time'
  } finally {
    workingTimeLoading.value = false
  }
}

watch(
  () => [userId.value, workingTimeId.value],
  () => getWorkingTime()
)
onMounted(() => getWorkingTime())
</script>

<template>
  <div v-if="workingTimeLoading && !workingTimeInitialized" class="space-y-4">
    <Skeleton class="h-10 w-1/2" />
    <Skeleton class="h-32 w-full" />
  </div>

  <div v-else-if="workingTimeError">
    {{ workingTimeError }}
  </div>

  <template v-else>
    <h1 class="mb-4 text-3xl font-bold">Working Time Manager</h1>

    <Table>
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
              format(new Date(workingTime.start), 'MMMM dd, yyyy hh:mm:ss aa')
            }}
          </TableCell>
          <TableCell class="text-center">
            {{ format(new Date(workingTime.end), 'MMMM dd, yyyy hh:mm:ss aa') }}
          </TableCell>
        </TableRow>
      </TableBody>
    </Table>

    <Separator class="mb-4 mt-8" />

    <h3 class="mb-4 text-2xl font-semibold">Actions</h3>

    <div class="flex items-center gap-x-2">
      <RouterLink
        :to="{
          name: 'working-time-create',
          params: { userId }
        }"
        :class="buttonVariants()"
      >
        <Plus class="size-4" />
        <span>Create a working time</span>
      </RouterLink>

      <EditWorkingTimeDialog
        :working-time="workingTime"
        :on-success="() => getWorkingTime()"
      >
        <Button>
          <Edit3 class="size-4" />
          <span>Edit</span>
        </Button>
      </EditWorkingTimeDialog>

      <DeleteWorkingTimeDialog>
        <Button variant="destructive">
          <Trash2 class="size-4" />
          <span>Delete</span>
        </Button>
      </DeleteWorkingTimeDialog>
    </div>
  </template>
</template>
