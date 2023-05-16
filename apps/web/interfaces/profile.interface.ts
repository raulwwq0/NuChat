import { Role } from '~~/enums/role.enum';

export interface Profile {
    id: string;
    username: string;
    full_name: string;
    avatar: string;
    role: Role;
}

export interface ProfileWithTotalMessages extends Profile {
    total_messages?: number;
    avatarUrl?: string;
}
