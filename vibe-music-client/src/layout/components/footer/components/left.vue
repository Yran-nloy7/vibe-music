<script setup lang="ts">
import { ref } from 'vue'
import { useAudioPlayer } from '@/hooks/useAudioPlayer'
import DrawerMusic from '@/components/DrawerMusic/index.vue'

const { currentTrack } = useAudioPlayer()
const showDrawerMusic = ref(false)
</script>

<template>
  <div
    class="flex items-center gap-2 w-64 cursor-pointer select-none hover:bg-hoverMenuBg transition-all duration-300 rounded-lg p-1 group"
    :class="{ 'scale-105 shadow-lg': showDrawerMusic }"
    @click="showDrawerMusic = !showDrawerMusic"
  >
    <div class="min-w-12 max-w-12 h-full relative">
      <img
        :src="currentTrack.cover + '?param=90y90'"
        :alt="currentTrack.title"
        class="w-full h-full object-cover rounded-lg m-1 transition-transform duration-500"
        :class="{ 'rotate-180 scale-110': showDrawerMusic }"
      />
      <div
        class="absolute inset-0 flex items-center justify-center transition-all duration-300"
        :class="showDrawerMusic ? 'opacity-100 scale-100' : 'opacity-0 scale-75'"
      >
        <icon-mdi:chevron-down
          class="text-white text-xl drop-shadow-lg transition-transform duration-500"
          :class="{ 'rotate-180': showDrawerMusic }"
        />
      </div>
    </div>
    <div class="flex-1 min-w-0">
      <div
        class="text-base text-primary-foreground line-clamp-1 mb-0.5 mx-2 transition-all duration-300"
        :class="{ 'text-lg font-semibold': showDrawerMusic }"
        :title="currentTrack.title"
      >
        {{ currentTrack.title }}
      </div>
      <div class="text-xs text-muted-foreground line-clamp-1 h-4 mt-0.5 mx-2">
        {{ currentTrack.artist }}
      </div>
    </div>
    <DrawerMusic v-model="showDrawerMusic" />
  </div>
</template>
