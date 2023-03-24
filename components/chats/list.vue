<script lang="ts" setup>
import { ChatResponse } from '~/types/response.types';

const supabase = useSupabaseClient();
const user = useSupabaseUser();

const chats = ref<ChatResponse[]>([]);

async function getAllChats() {
    // get all chats where the current user is a member
    const { data: chatIds } = await supabase
        .from('chats')
        .select('id, users:chat_user!inner(user_id)')
        .eq('users.user_id', user.value!.id)

    // get all chats with the user profiles without the current user
    return await supabase
    .from('chats')
    .select('*, users:chat_user!inner(profile:profiles(id, username, full_name, avatar_url))')
    .neq('users.user_id', user.value!.id)
    .in('id', chatIds?.map(chat => chat.id) || []);
}

const areChatsLoaded = computed(() => chats.value.length === 0);

onMounted(async () => {
    const { data: chatsData } = await getAllChats();

    for (const chat of chatsData!) {
        chats.value.push(chat);
    }
})
</script>

<template>
  <aside>
    <ul v-if="!areChatsLoaded">
      <li v-for="chat in chats" :key="chat.id">
        <ChatsCard :profile="chat.users[0].profile" />
      </li>
    </ul>
    <p v-else>Loading...</p>
  </aside>
</template>

<style scoped></style>
