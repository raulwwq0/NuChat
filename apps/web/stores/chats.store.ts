import { Chat } from '~~/interfaces/chat.interface';

export const useChatsStore = defineStore('chats', () => {
    const supabase = useSupabaseClient();
    const user = useSupabaseUser();
    const chats = ref<Chat[] | ['loading']>(['loading']);
    const chatsWatcher = ref();
    const areChatsEmpty = computed(() => chats.value.length === 0);
    const areChatsLoading = computed(() => chats.value[0] === 'loading');

    async function fetchAllUserChats() {
        const { data: chatIds } = await supabase
            .from('chats')
            .select('id, users:chat_user!inner(user_id)')
            .eq('users.user_id', user.value!.id);

        const { data: chatsResponse } = await supabase
            .from('chats')
            .select(
                '*, users:chat_user!inner(profile:profiles(id, username, full_name, avatar, role))'
            )
            .neq('users.user_id', user.value!.id)
            .in('id', chatIds?.map(chat => chat.id) || [])
            .order('last_message_at', { ascending: false });

        chats.value = [...(chatsResponse || [])];
    }

    function startChatsWatcher() {
        chatsWatcher.value = supabase
            .channel('chats-channel')
            .on(
                'postgres_changes',
                { event: '*', schema: 'public', table: 'chats' },
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
        areChatsEmpty,
        areChatsLoading,
        fetchAllUserChats,
        startChatsWatcher,
        stopChatsWatcher,
    };
});
