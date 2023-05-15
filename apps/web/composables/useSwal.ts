import Swal from 'sweetalert2';

export const useSwal = () => {
    const errorNotification = (message: string) => {
        Swal.fire({
            icon: 'error',
            title: 'Oops...',
            text: message,
        });
    };

    return {
        errorNotification,
    };
};
