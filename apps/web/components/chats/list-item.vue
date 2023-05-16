<script setup lang="ts">
    import { Role } from '~~/enums/role.enum';
    const { ifNeeded } = useDefaultAvatar();
    const isChatWithAdmin = (role: Role) => role === 'admin';

    defineProps<{
        data: any;
    }>();
</script>

<template>
    <VListItem
        :title="data.full_name"
        :subtitle="`@${data.username}`"
        :prepend-avatar="ifNeeded(data.avatar)"
    >
        <figure>
            <Icon
                v-if="isChatWithAdmin(data.role)"
                name="eos-icons:admin-outlined"
                class="admin-icon"
            />
            <VTooltip activator="parent" location="left">Nuchat Admin</VTooltip>
        </figure>
        <VDivider />
    </VListItem>
</template>

<style lang="scss" scoped>
    figure {
        position: absolute;
        top: 0;
        right: 0.3rem;
        font-size: 2rem;
        color: $primary;
        border-radius: 50%;
        padding: 0.5rem;
    }
</style>
