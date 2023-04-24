import { User } from './user.interface';

export interface Chat {
    id: string;
    created_at: string;
    users: User[];
}
