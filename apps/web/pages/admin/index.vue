<script lang="ts" setup>
    definePageMeta({
        middleware: ['empty-profile', 'authenticated', 'is-admin'],
    });
</script>

<template>
    <h1>Admin</h1>
</template>
