import { format } from 'date-fns'
import { ArrowDown, ArrowUp, ArrowUpDown, Eye } from 'lucide-vue-next'
import { h } from 'vue'
import { RouterLink } from 'vue-router'

import { Button } from '@/components/ui/button'

export const columns = [
  {
    accessorKey: 'id',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      const Icon =
        isSorted === 'asc'
          ? ArrowUp
          : isSorted === 'desc'
            ? ArrowDown
            : ArrowUpDown

      return h(
        Button,
        {
          variant: 'ghost',
          onClick: () => column.toggleSorting()
        },
        () => ['#', h(Icon, { class: 'size-4' })]
      )
    },
    cell: ({ row }) => {
      const value = row.getValue('id')
      return h('div', value)
    }
  },
  {
    accessorKey: 'start',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      const Icon =
        isSorted === 'asc'
          ? ArrowUp
          : isSorted === 'desc'
            ? ArrowDown
            : ArrowUpDown

      return h(
        Button,
        {
          variant: 'ghost',
          onClick: () => column.toggleSorting()
        },
        () => ['Start', h(Icon, { class: 'size-4' })]
      )
    },
    cell: ({ row }) => {
      const value = row.getValue('start')
      const date = format(new Date(value), 'MMMM dd, yyyy hh:mm:ss aa')
      return h('div', date)
    }
  },
  {
    accessorKey: 'end',
    header: ({ column }) => {
      const isSorted = column.getIsSorted()
      const Icon =
        isSorted === 'asc'
          ? ArrowUp
          : isSorted === 'desc'
            ? ArrowDown
            : ArrowUpDown

      return h(
        Button,
        {
          variant: 'ghost',
          onClick: () => column.toggleSorting()
        },
        () => ['End', h(Icon, { class: 'size-4' })]
      )
    },
    cell: ({ row }) => {
      const value = row.getValue('end')
      const date = format(new Date(value), 'MMMM dd, yyyy hh:mm:ss aa')
      return h('div', date)
    }
  },
  {
    id: 'actions',
    enableHiding: false,
    cell: ({ row }) => {
      const workingTime = row.original

      return h(
        'div',
        h(
          RouterLink,
          {
            to: {
              name: 'working-time',
              params: {
                workingTimeId: workingTime.id,
                userId: workingTime.user.id
              }
            }
          },
          () =>
            h(Button, { variant: 'ghost', size: 'iconXs' }, () =>
              h(Eye, { class: 'size-4' })
            )
        )
      )
    }
  }
]
