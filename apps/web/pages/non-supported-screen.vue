<template>
    <main>
        <div>;-;</div>
        <h1>Non supported screen</h1>
        <p>Sorry, NuChat is not supported on this screen size yet.</p>
    </main>
</template>

<style lang="scss" scoped>
    main {
        width: 80%;
        height: 100vh;
        margin: 0 auto;
        display: flex;
        flex-flow: column;
        justify-content: center;
        align-items: center;

        div {
            font-size: 10rem;
            font-weight: 700;
            color: #ccc;
            text-align: center;
            margin-bottom: 2rem;
        }

        h1 {
            font-size: 3rem;
            font-weight: 700;
            color: $primary;
            text-align: center;
            margin-bottom: 2rem;
        }

        p {
            font-size: 1.5rem;
            font-weight: 500;
            color: #333;
            text-align: center;
            width: 50%;
            margin-bottom: 1rem;
        }
    }
</style>
