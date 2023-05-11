import { Message, MessageType } from '~~/interfaces/message.interface';

export const useMessages = (chatId: string) => {
    const supabase = useSupabaseClient();
    const user = useSupabaseUser();
    const userId = computed(() => user.value?.id);

    const sendImage = async (path: string) => {
        const message: Message = {
            chat_id: chatId as string,
            user_id: userId.value as string,
            content: path,
            type: MessageType.IMAGE,
        };

        await supabase
            .from('messages')
            .insert([message as never])
            .single();
    };

    return {
        sendImage,
    };
};
