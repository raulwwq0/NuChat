import { Chat } from '@/interfaces/chat.interface';

export const useChatsStore = defineStore('chats', () => {
    const supabase = useSupabaseClient();
    const user = useSupabaseUser();
    const chats = ref<Chat[]>([]);
    const chatsWatcher = ref();
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

    function startChatsWatcher() {
        chatsWatcher.value = supabase
            .channel('chat-user-channel')
            .on(
                'postgres_changes',
                { event: '*', schema: 'public', table: 'chat_user' },
                async () => {
                    await fetchAllUserChats();
                }
            )
            .subscribe();
    }

    function stopChatsWatcher() {
        chatsWatcher.value?.unsubscribe();
    }

    return {
        chats,
        areChatsLoaded,
        fetchAllUserChats,
        startChatsWatcher,
        stopChatsWatcher,
    };
});
