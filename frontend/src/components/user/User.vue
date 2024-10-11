<script setup>
import { Edit3, Loader2, Plus, Trash2, Undo, User2 } from 'lucide-vue-next'
import { onMounted, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

import { Button } from '@/components/ui/button'

import { instance } from '../../api/instance'
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger
} from '../ui/accordion'
import CreateUserDialog from './CreateUserDialog.vue'
import DeleteUserDialog from './DeleteUserDialog.vue'
import EditUserDialog from './EditUserDialog.vue'

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
  <div class="rounded-md bg-zinc-100 p-4 shadow">
    <div v-if="userLoading" class="flex items-center gap-x-2">
      <Loader2 class="size-4 animate-spin" />
      <span>Loading...</span>
    </div>

    <div v-else-if="userError">
      {{ userError }}
    </div>

    <Accordion v-else type="single" collapsible>
      <AccordionItem value="user" class="border-none">
        <AccordionTrigger class="py-0">
          <div class="flex items-center gap-x-4">
            <div
              class="flex size-10 items-center justify-center rounded-full bg-zinc-200"
            >
              <User2 class="size-6" />
            </div>

            <div>
              <h1 class="text-left text-lg font-semibold leading-6">
                {{ user.username }}
              </h1>
              <p class="text-left text-sm leading-6 text-zinc-500">
                {{ user.email }}
              </p>
            </div>
          </div>
        </AccordionTrigger>

        <AccordionContent class="pb-0 pt-4">
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
        </AccordionContent>
      </AccordionItem>
    </Accordion>
  </div>
</template>
