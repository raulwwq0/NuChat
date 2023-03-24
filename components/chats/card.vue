<script lang="ts" setup>
import { ProfileResponse } from '~/types/response.types'

const props = defineProps({
  profile: {
    type: Object as PropType<ProfileResponse>,
    required: true,
  },
});
</script>

<template>
  <div>
    <h1>{{ props.profile.username }}</h1>
    <p>{{ props.profile.full_name }}</p>
  </div>
</template>

<style scoped></style>
