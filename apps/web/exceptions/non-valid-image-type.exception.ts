export class NonValidImageTypeException extends Error {
    constructor(message: string) {
        super(message);
        this.name = 'NonValidImageTypeException';
    }
}
