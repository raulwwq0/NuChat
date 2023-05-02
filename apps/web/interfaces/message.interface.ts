export enum MessageType {
    TEXT = 'text',
    IMAGE = 'image',
}

export interface Message {
    id?: string;
    created_at?: string;
    chat_id: string;
    user_id: string;
    content: string;
    type: MessageType;
}
