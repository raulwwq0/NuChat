# Supabase

[Supabase](https://supabase.com) is a Backend as a Service (BaaS) platform that provides developers a couple of fully-functional backend APIs built on top of a [Postgres](https://www.postgresql.org/) database with a bunch of new features.

The most common way of using Supabase is using their cloud services. However, for this project I decide to implement a [self-hosted solution using Docker](https://supabase.com/docs/guides/hosting/docker).

## Explaining Supabase APIs

Supabase already give us the following APIs to work with the database:

- **Rest API**: To perform the typical CRUD operations in our database.
- **Auth API**: To check user authentication.
- **Realtime API**: To create WebSocket connections with the different tables of our project and react to changes.
- **Storage API**: To handle the different files we want to upload and share in our app using buckets.

## Why I use Supabase?

### Reactive database

NuChat is a chat app, so one of the key feature is the possibility of sending messages to another user and refresh their client as soon as a new message is sent. With Supabase is easy to achieve using the Rest API to create those messages in the database and using the Realtime API WebSockets (together with Vue reactivity thanks to Nuxt) we can refresh the client messages immediately.

### Image uploads

You can also send images through NuChat. To store them in the corresponding bucket the Storage API provide a great way to do it and you don't need to worry about anything.

### Auth system

With Supabase Auth API you have a huge amount of ways to authenticate an user in your app (apart from the classic and boring user/password method...). I just decide to implement these methods:

- Magic Link: If you enter your email in NuChat sign in page, a new email will be sent to you with a link to login without anything else.
- One Time Password (OTP): In case you don't trust the previous link, in the same email you will found a code that you can enter in the sign in page modal that will pop up after we send the email.
- With a Github Account: To test one of the many providers I decide to use Github. You just need to click the _Sign in with Github_ button and it will redirect you to Github to accept NuChat to read you email from there.
