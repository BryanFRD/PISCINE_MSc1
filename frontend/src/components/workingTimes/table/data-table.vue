<script setup>
import { CalendarDate } from '@internationalized/date'
import { FlexRender, getCoreRowModel, useVueTable } from '@tanstack/vue-table'
import { endOfDay, format, startOfDay } from 'date-fns'
import { CalendarIcon } from 'lucide-vue-next'
import { onMounted, ref, shallowRef, watch } from 'vue'

import { instance } from '@/api/instance'
import { Button } from '@/components/ui/button'
import { Calendar } from '@/components/ui/calendar'
import {
  Popover,
  PopoverContent,
  PopoverTrigger
} from '@/components/ui/popover'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow
} from '@/components/ui/table'
import { cn, valueUpdater } from '@/lib/utils'

import { columns } from './columns'

const props = defineProps({
  userId: { type: Number, required: true }
})

const workingTimes = shallowRef([])
const totalCount = ref(0)
const workingTimesLoading = ref(false)

const sorting = ref([
  {
    id: 'start',
    desc: true
  }
])
const pagination = ref({
  pageIndex: 0,
  pageSize: 10
})
const filters = ref({
  start: null,
  end: null
})

const table = useVueTable({
  get data() {
    return workingTimes.value
  },
  columns,
  getCoreRowModel: getCoreRowModel(),
  manualSorting: true,
  manualPagination: true,
  state: {
    get sorting() {
      return sorting.value
    },
    get pagination() {
      return pagination.value
    }
  },
  onSortingChange: updaterOrValue => valueUpdater(updaterOrValue, sorting),
  onPaginationChange: updaterOrValue =>
    valueUpdater(updaterOrValue, pagination),
  enableSortingRemoval: true,
  get rowCount() {
    return totalCount.value
  }
})

const getWorkingTimes = async () => {
  workingTimesLoading.value = true

  try {
    const url = new URL(`${instance.defaults.baseURL}/workingtimes`)

    url.searchParams.append('page', pagination.value.pageIndex + 1)
    url.searchParams.append('per_page', pagination.value.pageSize)

    if (sorting.value.length > 0) {
      const sort = sorting.value[0]

      url.searchParams.append('order_by', sort.id)
      url.searchParams.append('order', sort.desc ? 'desc' : 'asc')
    }

    if (filters.value.start) {
      const date = filters.value.start.toDate()
      url.searchParams.append('start', startOfDay(date).toISOString())
    }
    if (filters.value.end) {
      const date = filters.value.end.toDate()
      url.searchParams.append('end', endOfDay(date).toISOString())
    }

    const searchParams = url.searchParams.toString()

    const result = await instance.get(
      `/workingtimes/${props.userId}/paginate?${searchParams}`
    )

    workingTimes.value = result.data.data
    totalCount.value = result.data.meta.total
  } finally {
    workingTimesLoading.value = false
  }
}

watch(
  () => [
    props.userId,
    sorting.value,
    pagination.value,
    filters.value.start,
    filters.value.end
  ],
  () => getWorkingTimes()
)
onMounted(() => getWorkingTimes())
</script>

<template>
  <div class="flex items-center gap-x-2 py-4">
    <Popover>
      <PopoverTrigger as-child>
        <Button
          variant="outline"
          :class="
            cn(
              'w-[240px] ps-3 text-start font-normal',
              !filters.start && 'text-muted-foreground'
            )
          "
        >
          <span>
            {{
              filters.start
                ? format(new Date(filters.start), 'MMMM dd, yyyy')
                : 'Start date'
            }}
          </span>
          <CalendarIcon class="ms-auto h-4 w-4 opacity-50" />
        </Button>
      </PopoverTrigger>
      <PopoverContent class="w-auto p-0">
        <Calendar
          v-model="filters.start"
          initial-focus
          :min-value="new CalendarDate(1900, 1, 1)"
        />
      </PopoverContent>
    </Popover>

    <Popover>
      <PopoverTrigger as-child>
        <Button
          variant="outline"
          :class="
            cn(
              'w-[240px] ps-3 text-start font-normal',
              !filters.end && 'text-muted-foreground'
            )
          "
        >
          <span>
            {{
              filters.end
                ? format(new Date(filters.end), 'MMMM dd, yyyy')
                : 'End date'
            }}
          </span>
          <CalendarIcon class="ms-auto h-4 w-4 opacity-50" />
        </Button>
      </PopoverTrigger>
      <PopoverContent class="w-auto p-0">
        <Calendar
          v-model="filters.end"
          initial-focus
          :min-value="new CalendarDate(1900, 1, 1)"
        />
      </PopoverContent>
    </Popover>
  </div>

  <div class="rounded-md border">
    <Table>
      <TableHeader>
        <TableRow
          v-for="headerGroup in table.getHeaderGroups()"
          :key="headerGroup.id"
        >
          <TableHead v-for="header in headerGroup.headers" :key="header.id">
            <FlexRender
              v-if="!header.isPlaceholder"
              :render="header.column.columnDef.header"
              :props="header.getContext()"
            />
          </TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        <template v-if="table.getRowModel().rows?.length">
          <TableRow
            v-for="row in table.getRowModel().rows"
            :key="row.id"
            :data-state="row.getIsSelected() ? 'selected' : undefined"
          >
            <TableCell v-for="cell in row.getVisibleCells()" :key="cell.id">
              <FlexRender
                :render="cell.column.columnDef.cell"
                :props="cell.getContext()"
              />
            </TableCell>
          </TableRow>
        </template>
        <template v-else>
          <TableRow>
            <TableCell :colspan="columns.length" class="h-24 text-center">
              No results.
            </TableCell>
          </TableRow>
        </template>
      </TableBody>
    </Table>
  </div>

  <div class="flex items-center justify-end gap-x-2 py-4">
    <span
      >Page {{ pagination.pageIndex + 1 }} of {{ table.getPageCount() }}</span
    >

    <Button
      variant="outline"
      size="sm"
      :disabled="!table.getCanPreviousPage()"
      @click="table.previousPage()"
    >
      Previous
    </Button>
    <Button
      variant="outline"
      size="sm"
      :disabled="!table.getCanNextPage()"
      @click="table.nextPage()"
    >
      Next
    </Button>
  </div>
</template>
