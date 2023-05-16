import { SupabaseException } from '~~/exceptions/supabase.exception';
import { Message } from '~~/interfaces/message.interface';
import { MessageType } from '~~/enums/message.enum';

export const useMessages = (chatId: string) => {
    const supabase = useSupabaseClient();
    const user = useSupabaseUser();
    const userId = computed(() => user.value?.id);
    const messagesWatcher = ref();

    const send = async (message: Message) => {
        const { error } = await supabase
            .from('messages')
            .insert([message as never])
            .single();

        if (error) {
            throw new SupabaseException(error.message);
        }
    };

    const sendImage = async (path: string) => {
        const message: Message = {
            chat_id: chatId as string,
            user_id: userId.value as string,
            content: path,
            type: MessageType.IMAGE,
        };

        const { error } = await supabase
            .from('messages')
            .insert([message as never])
            .single();

        if (error) {
            throw new SupabaseException(error.message);
        }
    };

    const get = async (): Promise<Message[]> => {
        const { data: messages, error } = await supabase
            .from('messages')
            .select('*')
            .eq('chat_id', chatId)
            .order('created_at', { ascending: true });

        if (error) {
            throw new SupabaseException(error.message);
        }

        return messages as Message[];
    };

    const startMessagesWatcher = (callback: Function) => {
        messagesWatcher.value = supabase
            .channel('messages-channel')
            .on(
                'postgres_changes',
                { event: '*', schema: 'public', table: 'messages' },
                () => {
                    callback();
                }
            )
            .subscribe();
    };

    const stopMessagesWatcher = () => {
        messagesWatcher.value?.unsubscribe();
    };

    return {
        send,
        sendImage,
        get,
        startMessagesWatcher,
        stopMessagesWatcher,
    };
};
