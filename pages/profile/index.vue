<script lang="ts" setup>
const user = useSupabaseUser();
</script>

<template>
  <div>
    Page: PROFILE
    {{ user }}
  </div>
</template>

<style scoped></style>
