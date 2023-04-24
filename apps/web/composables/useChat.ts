import { ChatUser } from '~~/interfaces/chat-user.interface';

export const useChat = () => {
    const supabase = useSupabaseClient();
    const user = useSupabaseUser();
    const chatId = crypto.randomUUID();

    const alreadyExists = async (userId: string): Promise<ChatUser[]> => {
        const { data: chatUsers, error: chatUsersError } = await supabase
            .from('chat_user')
            .select('*')
            .or(`user_id.eq.${userId},user_id.eq.${user.value!.id}`);

        if (chatUsersError) {
            console.error(chatUsersError);
            return [];
        }

        const duplicateChats: ChatUser[] = chatUsers!.filter(
            (chatUser: ChatUser, index) =>
                chatUsers.findIndex(
                    (otherChatUser: ChatUser) =>
                        otherChatUser.chat_id === chatUser.chat_id
                ) !== index
        );

        return duplicateChats;
    };

    const createRoom = async () => {
        const newChat = {
            id: chatId,
        };

        const { error: createChatError } = await supabase
            .from('chats')
            .insert([newChat as never]);

        if (createChatError) {
            console.error(createChatError);
        }
    };

    const addUsers = async (userId: string) => {
        const { error: createChatUserError } = await supabase
            .from('chat_user')
            .insert([
                {
                    chat_id: chatId,
                    user_id: userId,
                } as never,
                {
                    chat_id: chatId,
                    user_id: user.value!.id,
                } as never,
            ]);

        if (createChatUserError) {
            console.error(createChatUserError);
            return;
        }

        return chatId;
    };

    const create = async (userId: string) => {
        const existingChats = await alreadyExists(userId);

        if (existingChats.length > 0) {
            return existingChats[0].chat_id;
        }

        await createRoom();
        return addUsers(userId);
    };

    return {
        create,
    };
};
