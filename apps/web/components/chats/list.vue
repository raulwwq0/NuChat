<script lang="ts" setup>
    import { ChatResponse } from '~/types/response.types'

    const supabase = useSupabaseClient()
    const user = useSupabaseUser()

    const chats = ref<ChatResponse[]>([])

    async function getAllChats() {
        // get all chats where the current user is a member
        const { data: chatIds } = await supabase
            .from('chats')
            .select('id, users:chat_user!inner(user_id)')
            .eq('users.user_id', user.value!.id)

        // get all chats with the user profiles without the current user
        return await supabase
            .from('chats')
            .select(
                '*, users:chat_user!inner(profile:profiles(id, username, full_name, avatar_url))'
            )
            .neq('users.user_id', user.value!.id)
            .in('id', chatIds?.map(chat => chat.id) || [])
    }

    const areChatsLoaded = computed(() => chats.value.length === 0)

    onMounted(async () => {
        const { data: chatsData } = await getAllChats()

        for (const chat of chatsData!) {
            chats.value.push(chat)
        }
    })
</script>

<template>
    <aside>
        <section>
            <AuthLogout />
        </section>
        <section v-if="!areChatsLoaded">
            <NuxtLink
                v-for="chat in chats"
                :key="chat.id"
                :to="`/chats/${chat.id}/messages`"
            >
                <ChatsCard :profile="chat.users[0].profile" />
            </NuxtLink>
        </section>
        <span v-else>Loading...</span>
    </aside>
</template>

<style lang="scss" scoped>
    aside {
        display: flex;
        flex-flow: column;
        align-items: center;
        height: 100vh;
        width: 30%;
        background-color: $primary;

        section {
            display: flex;
            flex-flow: column;
            align-items: center;
            width: 100%;
            height: 100%;
            overflow-y: scroll;
        }
    }
</style>
