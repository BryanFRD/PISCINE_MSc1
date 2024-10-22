<script setup>
import { useColorMode } from '@vueuse/core'
import { Laptop, LogOut, Moon, Settings2, Sun } from 'lucide-vue-next'
import { computed } from 'vue'

import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuPortal,
  DropdownMenuSeparator,
  DropdownMenuSub,
  DropdownMenuSubContent,
  DropdownMenuSubTrigger,
  DropdownMenuTrigger
} from '@/components/ui/dropdown-menu'
import { useAuthStore } from '@/stores/authStore'

const authStore = useAuthStore()

const mode = useColorMode()

const user = computed(() => authStore.user)

const logOut = () => {
  authStore.user = null
  localStorage.removeItem('time-manager-token')
}
</script>

<template>
  <DropdownMenu>
    <DropdownMenuTrigger as-child>
      <slot name="trigger" />
    </DropdownMenuTrigger>

    <DropdownMenuContent align="end" class="w-56">
      <DropdownMenuLabel>
        <p>{{ user?.username }}</p>
        <p class="font-normal text-muted-foreground">{{ user?.email }}</p>
      </DropdownMenuLabel>

      <DropdownMenuSeparator />

      <DropdownMenuItem as-child class="gap-x-2">
        <RouterLink :to="{ name: 'account' }">
          <Settings2 class="size-4" />
          <span>Account</span>
        </RouterLink>
      </DropdownMenuItem>

      <DropdownMenuSub>
        <DropdownMenuSubTrigger class="gap-x-2">
          <Sun v-if="mode === 'light'" class="size-4" />
          <Moon v-else-if="mode === 'dark'" class="size-4" />
          <Laptop v-else class="size-4" />
          <span>Theme mode</span>
        </DropdownMenuSubTrigger>
        <DropdownMenuPortal>
          <DropdownMenuSubContent>
            <DropdownMenuItem class="gap-x-2" @click="mode = 'light'">
              <Sun class="size-4" />
              <span>Light</span>
            </DropdownMenuItem>
            <DropdownMenuItem class="gap-x-2" @click="mode = 'dark'">
              <Moon class="size-4" />
              <span>Dark</span>
            </DropdownMenuItem>
            <DropdownMenuItem class="gap-x-2" @click="mode = 'auto'">
              <Laptop class="size-4" />
              <span>System</span>
            </DropdownMenuItem>
          </DropdownMenuSubContent>
        </DropdownMenuPortal>
      </DropdownMenuSub>

      <DropdownMenuSeparator />

      <DropdownMenuItem class="gap-x-2" @click="logOut">
        <LogOut class="size-4" />
        <span>Log out</span>
      </DropdownMenuItem>
    </DropdownMenuContent>
  </DropdownMenu>
</template>
