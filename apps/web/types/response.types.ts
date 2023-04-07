export type ProfileResponse = {
    id: string
    username: string
    full_name: string
    avatar_url: string
}

export type UserResponse = {
    profile: ProfileResponse
}

export type ChatResponse = {
    id: string
    created_at: string
    users: UserResponse[]
}

export type MessageResponse = {
    id?: string
    created_at?: string
    chat_id: string
    user_id: string
    content: string
}
