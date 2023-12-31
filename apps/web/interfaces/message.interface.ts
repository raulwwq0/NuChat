import { MessageType } from '~~/enums/message.enum';

export interface Message {
    id?: string;
    created_at?: string;
    chat_id: string;
    user_id: string;
    content: string;
    type: MessageType;
}
