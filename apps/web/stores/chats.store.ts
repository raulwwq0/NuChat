import { Chat } from '@/interfaces/chat.interface';

export const useChatsStore = defineStore('chats', () => {
    const supabase = useSupabaseClient();
    const user = useSupabaseUser();
    const chats = ref<Chat[]>([]);
    const areChatsLoaded = computed(() => chats.value.length === 0);

    async function fetchAllUserChats() {
        const { data: chatIds } = await supabase
            .from('chats')
            .select('id, users:chat_user!inner(user_id)')
            .eq('users.user_id', user.value!.id);

        const { data: chatsResponse } = await supabase
            .from('chats')
            .select(
                '*, users:chat_user!inner(profile:profiles(id, username, full_name, avatar_url))'
            )
            .neq('users.user_id', user.value!.id)
            .in('id', chatIds?.map(chat => chat.id) || []);

        chats.value = [...(chatsResponse || [])];
    }

    return {
        chats,
        areChatsLoaded,
        fetchAllUserChats,
    };
});
